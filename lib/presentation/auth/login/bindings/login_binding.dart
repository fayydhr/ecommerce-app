import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/login_with_email_usecase.dart';
import 'package:ecommerce/domain/usecases/login_with_google_usecase.dart';
import 'package:ecommerce/presentation/auth/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        loginWithEmailUseCase: Get.find<LoginWithEmailUseCase>(),
        loginWithGoogleUseCase: Get.find<LoginWithGoogleUseCase>(),
      ),
    );
  }
}
