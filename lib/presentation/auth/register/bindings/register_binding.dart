import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/login_with_google_usecase.dart';
import 'package:ecommerce/domain/usecases/register_with_email_usecase.dart';
import 'package:ecommerce/presentation/auth/register/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        registerWithEmailUseCase: Get.find<RegisterWithEmailUseCase>(),
        loginWithGoogleUseCase: Get.find<LoginWithGoogleUseCase>(),
      ),
    );
  }
}
