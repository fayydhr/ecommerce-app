import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final SetFirstTimeCompleteUseCase setFirstTimeCompleteUseCase;

  OnboardingController({required this.setFirstTimeCompleteUseCase});

  Future<void> completeOnboarding() async {
    await setFirstTimeCompleteUseCase(const NoParams());
    Get.offAllNamed(Routes.login);
  }
}
