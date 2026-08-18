import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/presentation/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        checkFirstTimeUseCase: Get.find<CheckFirstTimeUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
      ),
    );
  }
}
