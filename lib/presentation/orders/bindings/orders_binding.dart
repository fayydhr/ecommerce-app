import 'package:get/get.dart';
import 'package:ecommerce/data/datasources/user_store_datasource.dart';
import 'package:ecommerce/presentation/orders/controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(
      () => OrdersController(
        userStoreDataSource: Get.find<UserStoreDataSource>(),
      ),
    );
  }
}
