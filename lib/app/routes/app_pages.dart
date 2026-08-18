import 'package:get/get.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/presentation/auth/forgot_password/bindings/forgot_password_binding.dart';
import 'package:ecommerce/presentation/auth/forgot_password/views/forgot_password_view.dart';
import 'package:ecommerce/presentation/auth/forgot_password/views/otp_verification_view.dart';
import 'package:ecommerce/presentation/auth/forgot_password/views/reset_password_view.dart';
import 'package:ecommerce/presentation/auth/login/bindings/login_binding.dart';
import 'package:ecommerce/presentation/auth/login/views/login_view.dart';
import 'package:ecommerce/presentation/auth/register/bindings/register_binding.dart';
import 'package:ecommerce/presentation/auth/register/views/register_view.dart';
import 'package:ecommerce/presentation/home/bindings/home_binding.dart';
import 'package:ecommerce/presentation/home/views/home_view.dart';
import 'package:ecommerce/presentation/notifications/bindings/notifications_binding.dart';
import 'package:ecommerce/presentation/notifications/views/notifications_view.dart';
import 'package:ecommerce/presentation/onboarding/bindings/onboarding_binding.dart';
import 'package:ecommerce/presentation/onboarding/views/onboarding_view.dart';
import 'package:ecommerce/presentation/product_detail/bindings/product_detail_binding.dart';
import 'package:ecommerce/presentation/product_detail/views/product_detail_view.dart';
import 'package:ecommerce/presentation/splash/bindings/splash_binding.dart';
import 'package:ecommerce/presentation/splash/views/splash_view.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => const OtpVerificationView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.productDetail,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
