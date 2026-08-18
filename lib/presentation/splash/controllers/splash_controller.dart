import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final CheckFirstTimeUseCase checkFirstTimeUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  SplashController({
    required this.checkFirstTimeUseCase,
    required this.getCurrentUserUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _startAppRouting();
  }

  Future<void> _startAppRouting() async {
    // Delay for smooth splash animation
    await Future.delayed(const Duration(milliseconds: 2500));

    final isFirstTimeResult = await checkFirstTimeUseCase(const NoParams());
    final isFirstTime = isFirstTimeResult.fold(
      (failure) => true,
      (value) => value,
    );

    if (isFirstTime) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    final userResult = await getCurrentUserUseCase(const NoParams());
    userResult.fold(
      (failure) => Get.offAllNamed(Routes.login),
      (user) {
        if (user != null) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.login);
        }
      },
    );
  }
}
