import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/send_password_reset_usecase.dart';
import 'package:ecommerce/presentation/auth/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        sendPasswordResetUseCase: Get.find<SendPasswordResetUseCase>(),
      ),
    );
  }
}
