import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ecommerce/presentation/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan controller terinisialisasi
    controller;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Vector Layer (Digeser agak naik)
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, -70),
                child: SvgPicture.asset(
                  'assets/icons/vector.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Exact Center Icon SVG
            Center(
              child: SvgPicture.asset(
                'assets/icons/icon.svg',
                width: 120,
                height: 120,
              ),
            ),

            // Loading Spinner di bagian bawah
            const Positioned(
              bottom: 64,
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
