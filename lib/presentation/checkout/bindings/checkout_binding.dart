import 'package:get/get.dart';
import 'package:ecommerce/data/datasources/user_store_datasource.dart';
import 'package:ecommerce/presentation/checkout/controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        userStoreDataSource: Get.find<UserStoreDataSource>(),
      ),
    );
  }
}
