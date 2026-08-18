import 'package:get/get.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/entities/product_entity.dart';

class ProductDetailController extends GetxController {
  late final ProductEntity product;

  final List<String> sizes = const ['S', 'M', 'L', 'XL'];
  final RxString selectedSize = 'M'.obs;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ProductEntity) {
      product = Get.arguments as ProductEntity;
    } else {
      // Fallback sample product
      product = const ProductEntity(
        id: 1,
        title: 'Fjallraven - Foldsack No. 1 Backpack',
        price: 109.95,
        description:
            'The name says it all, the right size slightly snugs the body leaving enough room for comfort in the sleeves and waist.',
        category: "men's clothing",
        image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
        ratingRate: 4.5,
        ratingCount: 120,
      );
    }
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void addToCart() {
    AppSnackbar.showSuccess(
      title: 'Added to Cart! 🛍️',
      message: '${product.title} (Size ${selectedSize.value}) added to your cart.',
    );
  }
}
