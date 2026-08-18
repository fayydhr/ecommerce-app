import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/usecases/login_with_email_usecase.dart';
import 'package:ecommerce/domain/usecases/login_with_google_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  LoginController({
    required this.loginWithEmailUseCase,
    required this.loginWithGoogleUseCase,
  });

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoadingEmail = false.obs;
  final RxBool isLoadingGoogle = false.obs;
  final RxBool rememberMe = true.obs;

  Future<void> loginWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    isLoadingEmail.value = true;
    final result = await loginWithEmailUseCase(
      LoginParams(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
    isLoadingEmail.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Masuk',
          message: failure.message,
        );
      },
      (user) {
        AppSnackbar.showSuccess(
          title: 'Selamat Datang!',
          message: 'Berhasil masuk sebagai ${user.displayName}',
        );
        Get.offAllNamed(Routes.home);
      },
    );
  }

  Future<void> loginWithGoogle() async {
    isLoadingGoogle.value = true;
    final result = await loginWithGoogleUseCase(const NoParams());
    isLoadingGoogle.value = false;

    result.fold(
      (failure) {
        if (!failure.message.toLowerCase().contains('dibatalkan')) {
          AppSnackbar.showError(
            title: 'Google Sign In',
            message: failure.message,
          );
        }
      },
      (user) {
        AppSnackbar.showSuccess(
          title: 'Selamat Datang!',
          message: 'Berhasil masuk dengan Google sebagai ${user.displayName}',
        );
        Get.offAllNamed(Routes.home);
      },
    );
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
