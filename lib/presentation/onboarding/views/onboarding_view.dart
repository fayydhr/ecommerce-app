import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/presentation/onboarding/controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Background Vector SVG (Full width & cover)
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/icons/vectoronboarding.svg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // 2. Large Bold Typography Header
            Positioned(
              top: 12,
              left: 24,
              right: 24,
              child: Text(
                'Define\nyourself in\nyour unique\nway.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 75,
                  fontWeight: FontWeight.w800,
                  height: 0.85,
                  letterSpacing: -4.0,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),

            // 3. Model Image (Full-bleed width layered over vector & behind text)
            Positioned(
              left: 0,
              right: 0,
              bottom: 84,
              top: 110,
              child: Image.asset(
                'assets/images/image.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // 4. Bottom Action Button
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
