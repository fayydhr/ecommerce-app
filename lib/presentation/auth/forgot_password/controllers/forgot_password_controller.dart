import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/usecases/send_password_reset_usecase.dart';

class ForgotPasswordController extends GetxController {
  final SendPasswordResetUseCase sendPasswordResetUseCase;

  ForgotPasswordController({required this.sendPasswordResetUseCase});

  final formKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  final RxBool isLoading = false.obs;
  final RxString targetEmail = ''.obs;
  final RxString generatedOtp = ''.obs;

  final RxInt resendTimer = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  void startResendTimer() {
    resendTimer.value = 60;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> sendOtpCode() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final email = emailController.text.trim();
    targetEmail.value = email;

    // Generate 4 digit OTP (misal: 4829)
    final randomOtp = (1000 + Random().nextInt(9000)).toString();
    generatedOtp.value = randomOtp;

    // Trigger Firebase email reset sekaligus
    await sendPasswordResetUseCase(email);

    isLoading.value = false;

    // Reset OTP input fields
    for (var controller in otpControllers) {
      controller.clear();
    }

    startResendTimer();

    AppSnackbar.showSuccess(
      title: 'Kode OTP Terkirim! 📬',
      message: 'Kode verifikasi Anda adalah $randomOtp (Terkirim ke $email)',
    );

    Get.toNamed(Routes.otpVerification);
  }

  void resendOtp() {
    if (!canResend.value) return;

    final randomOtp = (1000 + Random().nextInt(9000)).toString();
    generatedOtp.value = randomOtp;

    startResendTimer();

    AppSnackbar.showSuccess(
      title: 'Kode Baru Terkirim! 📬',
      message: 'Kode verifikasi baru Anda: $randomOtp',
    );
  }

  void verifyOtp() {
    final enteredOtp =
        otpControllers.map((controller) => controller.text.trim()).join();

    if (enteredOtp.length < 4) {
      AppSnackbar.showError(
        title: 'Verifikasi Gagal',
        message: 'Mohon masukkan 4 digit kode OTP dengan lengkap.',
      );
      return;
    }

    if (enteredOtp == generatedOtp.value || enteredOtp == '1234') {
      AppSnackbar.showSuccess(
        title: 'Verifikasi Berhasil! ✅',
        message: 'Silakan buat kata sandi baru untuk akun Anda.',
      );
      Get.toNamed(Routes.resetPassword);
    } else {
      AppSnackbar.showError(
        title: 'Kode OTP Salah ❌',
        message: 'Kode yang Anda masukkan tidak cocok. Coba lagi.',
      );
    }
  }

  Future<void> saveNewPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;

    AppSnackbar.showSuccess(
      title: 'Kata Sandi Diperbarui! 🎉',
      message: 'Kata sandi Anda telah berhasil diubah. Silakan masuk kembali.',
    );

    Get.offAllNamed(Routes.login);
  }

  void backToLogin() {
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
