import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/usecases/login_with_google_usecase.dart';
import 'package:ecommerce/domain/usecases/register_with_email_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class RegisterController extends GetxController {
  final RegisterWithEmailUseCase registerWithEmailUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  RegisterController({
    required this.registerWithEmailUseCase,
    required this.loginWithGoogleUseCase,
  });

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoadingRegister = false.obs;
  final RxBool isLoadingGoogle = false.obs;
  final RxBool agreeTerms = true.obs;

  Future<void> registerWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    if (!agreeTerms.value) {
      AppSnackbar.showError(
        title: 'Syarat & Ketentuan',
        message: 'Mohon setujui syarat dan ketentuan untuk mendaftar',
      );
      return;
    }

    isLoadingRegister.value = true;
    final result = await registerWithEmailUseCase(
      RegisterParams(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
    isLoadingRegister.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Mendaftar',
          message: failure.message,
        );
      },
      (user) {
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
        Get.offAllNamed(Routes.home);
      },
    );
  }

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
