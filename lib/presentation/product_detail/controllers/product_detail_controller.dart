import 'package:get/get.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/data/datasources/user_store_datasource.dart';
import 'package:ecommerce/domain/entities/product_entity.dart';
import 'package:ecommerce/presentation/home/controllers/home_controller.dart';

class ProductDetailController extends GetxController {
  final UserStoreDataSource userStoreDataSource =
      Get.find<UserStoreDataSource>();

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

    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final ids = await userStoreDataSource.getWishlistProductIds();
    isFavorite.value = ids.contains(product.id);
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  Future<void> toggleFavorite() async {
    isFavorite.value = !isFavorite.value;
    await userStoreDataSource.toggleWishlistProduct(product);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadWishlist();
    }
  }

  Future<void> addToCart() async {
    await userStoreDataSource.addToCart(product, selectedSize.value);

    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      await homeController.loadCart();
      homeController.changeNavIndex(3);
      Get.back();
    } else {
      Get.offAllNamed(Routes.home);
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        await homeController.loadCart();
        homeController.changeNavIndex(3);
      }
    }
  }
}
