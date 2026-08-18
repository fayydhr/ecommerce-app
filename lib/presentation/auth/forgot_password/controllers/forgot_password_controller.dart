import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/usecases/send_password_reset_usecase.dart';

class ForgotPasswordController extends GetxController {
  final SendPasswordResetUseCase sendPasswordResetUseCase;

  ForgotPasswordController({required this.sendPasswordResetUseCase});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;

  Future<void> sendResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final result = await sendPasswordResetUseCase(emailController.text.trim());
    isLoading.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Mengirim Email',
          message: failure.message,
        );
      },
      (_) {
        isEmailSent.value = true;
        AppSnackbar.showSuccess(
          title: 'Email Terkirim!',
          message: 'Tautan pemulihan kata sandi telah dikirim ke email Anda.',
        );
      },
    );
  }

  void backToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
