import 'package:get/get.dart';
import 'package:ecommerce/data/datasources/user_store_datasource.dart';
import 'package:ecommerce/domain/entities/order_item_entity.dart';

class OrdersController extends GetxController {
  final UserStoreDataSource userStoreDataSource;

  OrdersController({required this.userStoreDataSource});

  final RxInt selectedTabIndex = 0.obs; // 0: Ongoing, 1: Completed
  final RxList<OrderItemEntity> allOrders = <OrderItemEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    final orders = await userStoreDataSource.getOrders();
    allOrders.assignAll(orders);
    isLoading.value = false;
  }

  void setTab(int index) {
    selectedTabIndex.value = index;
  }

  List<OrderItemEntity> get ongoingOrders {
    return allOrders.where((o) => !o.isCompleted).toList();
  }

  List<OrderItemEntity> get completedOrders {
    return allOrders.where((o) => o.isCompleted).toList();
  }

  List<OrderItemEntity> get currentFilteredOrders {
    return selectedTabIndex.value == 0 ? ongoingOrders : completedOrders;
  }
}
