import 'package:get/get.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/presentation/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(
        setFirstTimeCompleteUseCase: Get.find<SetFirstTimeCompleteUseCase>(),
      ),
    );
  }
}
