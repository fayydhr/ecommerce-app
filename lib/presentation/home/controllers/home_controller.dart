import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/entities/product_entity.dart';
import 'package:ecommerce/domain/entities/user_entity.dart';
import 'package:ecommerce/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce/domain/usecases/logout_usecase.dart';

class HomeController extends GetxController {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  HomeController({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
  });

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  final RxList<String> categories = <String>['All'].obs;
  final RxString selectedCategory = 'All'.obs;

  final RxList<ProductEntity> allProducts = <ProductEntity>[].obs;
  final RxList<ProductEntity> displayProducts = <ProductEntity>[].obs;

  final RxSet<int> favoriteProductIds = <int>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    loadCategories();
    loadProducts();
  }

  Future<void> loadCurrentUser() async {
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => null,
      (user) => currentUser.value = user,
    );
  }

  Future<void> loadCategories() async {
    final result = await getCategoriesUseCase(const NoParams());
    result.fold(
      (failure) {
        // Default fallback categories
        categories.assignAll([
          'All',
          "men's clothing",
          "women's clothing",
          'jewelery',
          'electronics',
        ]);
      },
      (data) {
        final list = ['All', ...data];
        categories.assignAll(list);
      },
    );
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    final result = await getProductsUseCase(const NoParams());
    isLoading.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Memuat Produk',
          message: failure.message,
        );
      },
      (products) {
        allProducts.assignAll(products);
        _applyFilters();
      },
    );
  }

  Future<void> selectCategory(String category) async {
    selectedCategory.value = category;
    if (category == 'All') {
      _applyFilters();
      return;
    }

    isLoading.value = true;
    final result = await getProductsByCategoryUseCase(category);
    isLoading.value = false;

    result.fold(
      (failure) {
        _applyFilters();
      },
      (products) {
        displayProducts.assignAll(products);
      },
    );
  }

  void onSearchChanged(String query) {
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    var list = allProducts.toList();

    if (selectedCategory.value != 'All') {
      list = list
          .where((p) =>
              p.category.toLowerCase() == selectedCategory.value.toLowerCase())
          .toList();
    }

    if (query.isNotEmpty) {
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query))
          .toList();
    }

    displayProducts.assignAll(list);
  }

  void toggleFavorite(int productId) {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
    } else {
      favoriteProductIds.add(productId);
    }
  }

  bool isFavorite(int productId) => favoriteProductIds.contains(productId);

  Future<void> logout() async {
    isLoggingOut.value = true;
    final result = await logoutUseCase(const NoParams());
    isLoggingOut.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Keluar',
          message: failure.message,
        );
      },
      (_) {
        AppSnackbar.showSuccess(
          title: 'Berhasil Keluar',
          message: 'Sampai jumpa kembali!',
        );
        Get.offAllNamed(Routes.login);
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
