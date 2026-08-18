import 'package:flutter/material.dart';
import 'package:ecommerce/app/config/app_colors.dart';
import 'package:ecommerce/app/config/app_text_styles.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Logo G
                      const GoogleLogo(),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;
    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    // Draw stylized multi-colored G shape
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Red arc (top)
    final pathRed = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, -3.14 * 0.75, 3.14 * 0.5, false)
      ..close();
    canvas.drawPath(pathRed, paintRed);

    // Yellow arc (left)
    final pathYellow = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, -3.14 * 1.25, 3.14 * 0.5, false)
      ..close();
    canvas.drawPath(pathYellow, paintYellow);

    // Green arc (bottom)
    final pathGreen = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, 3.14 * 0.25, 3.14 * 0.5, false)
      ..close();
    canvas.drawPath(pathGreen, paintGreen);

    // Blue arc & bar (right)
    final pathBlue = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, -3.14 * 0.25, 3.14 * 0.5, false)
      ..close();
    canvas.drawPath(pathBlue, paintBlue);

    // Center cutout to make ring
    final paintWhite = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, paintWhite);

    // Blue horizontal bar
    final barRect = Rect.fromLTRB(
      center.dx,
      center.dy - radius * 0.22,
      w,
      center.dy + radius * 0.22,
    );
    canvas.drawRect(barRect, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
