class CartItemEntity {
  final String id;
  final int productId;
  final String title;
  final double price;
  final String image;
  final String size;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.size,
    required this.quantity,
  });

  CartItemEntity copyWith({
    String? id,
    int? productId,
    String? title,
    double? price,
    String? image,
    String? size,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      size: json['size'] as String? ?? 'M',
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
