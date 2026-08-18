import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/domain/usecases/logout_usecase.dart';
import 'package:ecommerce/presentation/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
    );
  }
}
