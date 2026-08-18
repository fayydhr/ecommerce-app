import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/app/config/app_colors.dart';
import 'package:ecommerce/app/config/app_text_styles.dart';
import 'package:ecommerce/app/utils/validators.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/core/widgets/custom_text_field.dart';
import 'package:ecommerce/presentation/auth/forgot_password/controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: controller.backToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Obx(
            () => controller.isEmailSent.value
                ? _buildSuccessView()
                : _buildFormView(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Illustration
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 24),

          // Title & Subtitle
          Text(
            'Lupa Kata Sandi? 🔒',
            style: AppTextStyles.h1.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 8),
          Text(
            'Jangan khawatir! Masukkan alamat email yang terdaftar untuk menerima tautan pemulihan kata sandi.',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 32),

          // Email Field
          CustomTextField(
            label: 'Alamat Email',
            hintText: 'nama@example.com',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
            ),
            validator: AppValidators.validateEmail,
          ),
          const SizedBox(height: 32),

          // Send Reset Link Button
          Obx(
            () => CustomButton(
              text: 'Kirim Tautan Pemulihan',
              isLoading: controller.isLoading.value,
              onPressed: controller.sendResetEmail,
            ),
          ),
          const SizedBox(height: 24),

          // Back to Login Button
          CustomButton(
            text: 'Kembali ke Masuk',
            isOutlined: true,
            onPressed: controller.backToLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.success,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Email Terkirim! 📬',
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 12),
        Text(
          'Kami telah mengirimkan tautan pemulihan ke ${controller.emailController.text}. Silakan periksa kotak masuk atau folder spam Anda.',
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: 40),
        CustomButton(
          text: 'Kembali ke Halaman Masuk',
          onPressed: controller.backToLogin,
        ),
      ],
    );
  }
}
