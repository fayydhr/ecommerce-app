import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/domain/entities/user_entity.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/domain/usecases/logout_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  HomeController({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  });

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => null,
      (user) => currentUser.value = user,
    );
  }

  Future<void> logout() async {
    isLoading.value = true;
    final result = await logoutUseCase(const NoParams());
    isLoading.value = false;

    result.fold(
      (failure) {
        AppSnackbar.showError(
          title: 'Gagal Keluar',
          message: failure.message,
        );
      },
      (_) {
        AppSnackbar.showInfo(
          title: 'Sampai Jumpa!',
          message: 'Anda telah berhasil keluar dari akun.',
        );
        Get.offAllNamed(Routes.login);
      },
    );
  }
}
