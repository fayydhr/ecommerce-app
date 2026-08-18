import 'package:get/get.dart';
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
    // Delay 3 detik sebelum masuk ke onboarding
    await Future.delayed(const Duration(seconds: 3));

    // Selalu arahkan ke Onboarding untuk keperluan testing/desain
    Get.offAllNamed(Routes.onboarding);
  }
}
