import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/app/config/app_colors.dart';
import 'package:ecommerce/app/config/app_text_styles.dart';
import 'package:ecommerce/app/utils/validators.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/core/widgets/custom_text_field.dart';
import 'package:ecommerce/core/widgets/social_auth_button.dart';
import 'package:ecommerce/presentation/auth/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo / Header Icon
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title & Subtitle
                  Text(
                    'Selamat Datang Kembali! 👋',
                    style: AppTextStyles.h1.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk ke akunmu untuk melanjutkan belanja dan nikmati promo terbaik.',
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
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 12),

                  // Remember Me & Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (val) =>
                                    controller.rememberMe.value = val ?? false,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ingat saya',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: controller.goToForgotPassword,
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Login Button
                  Obx(
                    () => CustomButton(
                      text: 'Masuk',
                      isLoading: controller.isLoadingEmail.value,
                      onPressed: controller.loginWithEmail,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider "Atau masuk dengan"
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.border, thickness: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'atau masuk dengan',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.border, thickness: 1.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Google Sign-In Button
                  Obx(
                    () => SocialAuthButton(
                      text: 'Masuk dengan Google',
                      isLoading: controller.isLoadingGoogle.value,
                      onPressed: controller.loginWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Register Footer Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goToRegister,
                        child: Text(
                          'Daftar Sekarang',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
