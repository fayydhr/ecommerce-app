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
            // Background Vector Layers
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/vector.svg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/vector2.svg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/vector3.svg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/vector4.svg',
                fit: BoxFit.cover,
              ),
            ),

            // Center Content: Icon & Loading Spinner
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center Icon SVG
                SvgPicture.asset(
                  'assets/icons/icon.svg',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 200),

                // Animated Circular Loading Spinner
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
