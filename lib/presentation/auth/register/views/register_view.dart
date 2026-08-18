import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/app/config/app_colors.dart';
import 'package:ecommerce/app/config/app_text_styles.dart';
import 'package:ecommerce/app/utils/validators.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/core/widgets/custom_text_field.dart';
import 'package:ecommerce/core/widgets/social_auth_button.dart';
import 'package:ecommerce/presentation/auth/register/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: controller.goToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Subtitle
                Text(
                  'Buat Akun Baru ✨',
                  style: AppTextStyles.h1.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftar sekarang untuk memulai pengalaman belanja online yang menyenangkan.',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 28),

                // Name Field
                CustomTextField(
                  label: 'Nama Lengkap',
                  hintText: 'John Doe',
                  controller: controller.nameController,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textSecondary,
                  ),
                  validator: AppValidators.validateName,
                ),
                const SizedBox(height: 18),

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
                const SizedBox(height: 18),

                // Password Field
                CustomTextField(
                  label: 'Kata Sandi',
                  hintText: 'Minimal 6 karakter',
                  controller: controller.passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textSecondary,
                  ),
                  validator: AppValidators.validatePassword,
                ),
                const SizedBox(height: 18),

                // Confirm Password Field
                CustomTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hintText: 'Ulangi kata sandi Anda',
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  prefixIcon: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.textSecondary,
                  ),
                  validator: (val) => AppValidators.validateConfirmPassword(
                    val,
                    controller.passwordController.text,
                  ),
                ),
                const SizedBox(height: 16),

                // Terms & Conditions Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: controller.agreeTerms.value,
                          onChanged: (val) =>
                              controller.agreeTerms.value = val ?? false,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Saya menyetujui ',
                          style: AppTextStyles.bodySmall,
                          children: [
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' serta '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Sign Up Button
                Obx(
                  () => CustomButton(
                    text: 'Daftar Akun',
                    isLoading: controller.isLoadingRegister.value,
                    onPressed: controller.registerWithEmail,
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.border, thickness: 1.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'atau daftar dengan',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.border, thickness: 1.2),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Google Button
                Obx(
                  () => SocialAuthButton(
                    text: 'Daftar dengan Google',
                    isLoading: controller.isLoadingGoogle.value,
                    onPressed: controller.loginWithGoogle,
                  ),
                ),
                const SizedBox(height: 32),

                // Footer Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Masuk Disini',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
