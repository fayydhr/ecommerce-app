import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/app/routes/app_routes.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

class OnboardingController extends GetxController {
  final SetFirstTimeCompleteUseCase setFirstTimeCompleteUseCase;

  OnboardingController({required this.setFirstTimeCompleteUseCase});

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      title: 'Temukan Produk Impian',
      description:
          'Ribuan produk berkualitas tinggi dari brand ternama lokal dan global siap melengkapi gaya hidupmu.',
      icon: Icons.storefront_rounded,
      accentColor: Color(0xFF6C5CE7),
    ),
    OnboardingItem(
      title: 'Pembayaran Cepat & Aman',
      description:
          'Nikmati kemudahan transaksi dengan berbagai metode pembayaran digital yang terjamin 100% aman.',
      icon: Icons.shield_rounded,
      accentColor: Color(0xFF00CEC9),
    ),
    OnboardingItem(
      title: 'Pengiriman Kilat ke Rumah',
      description:
          'Lacak pesananmu secara real-time dan terima paket tepat waktu dengan kurir pilihan terpercaya.',
      icon: Icons.local_shipping_rounded,
      accentColor: Color(0xFFFF7675),
    ),
  ];

  bool get isLastPage => currentPage.value == items.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    await setFirstTimeCompleteUseCase(const NoParams());
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
