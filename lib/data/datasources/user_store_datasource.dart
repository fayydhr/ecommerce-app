import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/domain/entities/order_item_entity.dart';
import 'package:ecommerce/domain/entities/product_entity.dart';

abstract class UserStoreDataSource {
  Future<Set<int>> getWishlistProductIds();
  Future<void> toggleWishlistProduct(ProductEntity product);
  Future<List<ProductEntity>> getWishlistProducts();

  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(ProductEntity product, String size);
  Future<void> updateCartQuantity(String cartItemId, int delta);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();

  Future<List<OrderItemEntity>> getOrders();
  Future<void> addOrders(List<OrderItemEntity> newOrders);
}

class UserStoreDataSourceImpl implements UserStoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final SharedPreferences sharedPreferences;

  static const String _localWishlistKey = 'local_wishlist_ids';
  static const String _localWishlistProductsKey = 'local_wishlist_products';
  static const String _localCartKey = 'local_cart_items';

  UserStoreDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.sharedPreferences,
  });

  String? get _currentUid => auth.currentUser?.uid;

  // ==================== WISHLIST / SAVED ====================

  @override
  Future<Set<int>> getWishlistProductIds() async {
    final uid = _currentUid;
    if (uid != null) {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('wishlist')
            .get();
        final ids = snapshot.docs
            .map((doc) => int.tryParse(doc.id) ?? (doc.data()['id'] as int? ?? 0))
            .where((id) => id > 0)
            .toSet();

        // Sync to local cache
        await _saveLocalWishlistIds(ids);
        return ids;
      } catch (e) {
        if (kDebugMode) print('Firestore wishlist fetch error, using local cache: $e');
      }
    }

    return _getLocalWishlistIds();
  }

  @override
  Future<void> toggleWishlistProduct(ProductEntity product) async {
    final localIds = _getLocalWishlistIds();
    final localProducts = _getLocalWishlistProducts();

    final isFav = localIds.contains(product.id);
    if (isFav) {
      localIds.remove(product.id);
      localProducts.removeWhere((p) => p.id == product.id);
    } else {
      localIds.add(product.id);
      localProducts.add(product);
    }

    await _saveLocalWishlistIds(localIds);
    await _saveLocalWishlistProducts(localProducts);

    final uid = _currentUid;
    if (uid != null) {
      try {
        final docRef = firestore
            .collection('users')
            .doc(uid)
            .collection('wishlist')
            .doc(product.id.toString());

        if (isFav) {
          await docRef.delete();
        } else {
          await docRef.set({
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'image': product.image,
            'category': product.category,
            'description': product.description,
            'ratingRate': product.ratingRate,
            'ratingCount': product.ratingCount,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        if (kDebugMode) print('Firestore wishlist sync error: $e');
      }
    }
  }

  @override
  Future<List<ProductEntity>> getWishlistProducts() async {
    final uid = _currentUid;
    if (uid != null) {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('wishlist')
            .get();

        final list = snapshot.docs.map((doc) {
          final d = doc.data();
          return ProductEntity(
            id: d['id'] as int? ?? 0,
            title: d['title'] as String? ?? '',
            price: (d['price'] as num?)?.toDouble() ?? 0.0,
            image: d['image'] as String? ?? '',
            category: d['category'] as String? ?? '',
            description: d['description'] as String? ?? '',
            ratingRate: (d['ratingRate'] as num?)?.toDouble() ?? 0.0,
            ratingCount: d['ratingCount'] as int? ?? 0,
          );
        }).toList();

        await _saveLocalWishlistProducts(list);
        return list;
      } catch (e) {
        if (kDebugMode) print('Firestore wishlist products error: $e');
      }
    }

    return _getLocalWishlistProducts();
  }

  // ==================== CART ====================

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final uid = _currentUid;
    if (uid != null) {
      try {
        final snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('cart')
            .get();

        final items = snapshot.docs.map((doc) {
          final data = doc.data();
          return CartItemEntity.fromJson(data);
        }).toList();

        await _saveLocalCart(items);
        return items;
      } catch (e) {
        if (kDebugMode) print('Firestore cart fetch error, using local cache: $e');
      }
    }

    return _getLocalCart();
  }

  @override
  Future<void> addToCart(ProductEntity product, String size) async {
    final items = _getLocalCart();
    final cartItemId = '${product.id}_$size';

    final existingIndex = items.indexWhere((item) => item.id == cartItemId);
    if (existingIndex >= 0) {
      final current = items[existingIndex];
      items[existingIndex] = current.copyWith(quantity: current.quantity + 1);
    } else {
      items.add(
        CartItemEntity(
          id: cartItemId,
          productId: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          size: size,
          quantity: 1,
        ),
      );
    }

    await _saveLocalCart(items);

    final uid = _currentUid;
    if (uid != null) {
      final targetItem = items.firstWhere((item) => item.id == cartItemId);
      firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(cartItemId)
          .set(targetItem.toJson())
          .catchError((e) {
        if (kDebugMode) print('Firestore cart add error: $e');
      });
    }
  }

  @override
  Future<void> updateCartQuantity(String cartItemId, int delta) async {
    final items = _getLocalCart();
    final index = items.indexWhere((item) => item.id == cartItemId);
    if (index < 0) return;

    final newQty = items[index].quantity + delta;
    if (newQty <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    items[index] = items[index].copyWith(quantity: newQty);
    await _saveLocalCart(items);

    final uid = _currentUid;
    if (uid != null) {
      firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': newQty})
          .catchError((e) {
        if (kDebugMode) print('Firestore cart quantity update error: $e');
      });
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    final items = _getLocalCart();
    items.removeWhere((item) => item.id == cartItemId);
    await _saveLocalCart(items);

    final uid = _currentUid;
    if (uid != null) {
      firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(cartItemId)
          .delete()
          .catchError((e) {
        if (kDebugMode) print('Firestore cart remove error: $e');
      });
    }
  }

  @override
  Future<void> clearCart() async {
    await _saveLocalCart([]);

    final uid = _currentUid;
    if (uid != null) {
      firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      }).catchError((e) {
        if (kDebugMode) print('Firestore clear cart error: $e');
      });
    }
  }

  // ==================== LOCAL STORAGE HELPERS ====================

  Set<int> _getLocalWishlistIds() {
    final raw = sharedPreferences.getStringList(_localWishlistKey) ?? [];
    return raw.map((e) => int.tryParse(e) ?? 0).where((id) => id > 0).toSet();
  }

  Future<void> _saveLocalWishlistIds(Set<int> ids) async {
    await sharedPreferences.setStringList(
      _localWishlistKey,
      ids.map((e) => e.toString()).toList(),
    );
  }

  List<ProductEntity> _getLocalWishlistProducts() {
    final raw = sharedPreferences.getString(_localWishlistProductsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = json.decode(raw);
      return list.map((item) {
        return ProductEntity(
          id: item['id'] as int? ?? 0,
          title: item['title'] as String? ?? '',
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          image: item['image'] as String? ?? '',
          category: item['category'] as String? ?? '',
          description: item['description'] as String? ?? '',
          ratingRate: (item['ratingRate'] as num?)?.toDouble() ?? 0.0,
          ratingCount: item['ratingCount'] as int? ?? 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveLocalWishlistProducts(List<ProductEntity> products) async {
    final encoded = json.encode(
      products
          .map((p) => {
                'id': p.id,
                'title': p.title,
                'price': p.price,
                'image': p.image,
                'category': p.category,
                'description': p.description,
                'ratingRate': p.ratingRate,
                'ratingCount': p.ratingCount,
              })
          .toList(),
    );
    await sharedPreferences.setString(_localWishlistProductsKey, encoded);
  }

  List<CartItemEntity> _getLocalCart() {
    final raw = sharedPreferences.getString(_localCartKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = json.decode(raw);
      return list.map((item) => CartItemEntity.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveLocalCart(List<CartItemEntity> items) async {
    final encoded = json.encode(items.map((i) => i.toJson()).toList());
    await sharedPreferences.setString(_localCartKey, encoded);
  }

  static const String _localOrdersKey = 'local_orders_list';

  @override
  Future<List<OrderItemEntity>> getOrders() async {
    final local = _getLocalOrders();
    return local;
  }

  @override
  Future<void> addOrders(List<OrderItemEntity> newOrders) async {
    final list = _getLocalOrders();
    list.insertAll(0, newOrders);
    await _saveLocalOrders(list);

    final uid = _currentUid;
    if (uid != null) {
      for (final o in newOrders) {
        firestore
            .collection('users')
            .doc(uid)
            .collection('orders')
            .doc(o.id)
            .set(o.toJson())
            .catchError((e) {
          if (kDebugMode) print('Firestore order add error: $e');
        });
      }
    }
  }

  List<OrderItemEntity> _getLocalOrders() {
    final raw = sharedPreferences.getString(_localOrdersKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> list = json.decode(raw);
      return list
          .map((item) => OrderItemEntity.fromJson(item))
          .where((item) => item.id != 'ord_101' && item.id != 'ord_102' && item.id != 'ord_103')
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveLocalOrders(List<OrderItemEntity> items) async {
    final encoded = json.encode(items.map((i) => i.toJson()).toList());
    await sharedPreferences.setString(_localOrdersKey, encoded);
  }
}
