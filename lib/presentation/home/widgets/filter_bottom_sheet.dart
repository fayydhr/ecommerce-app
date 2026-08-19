import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/presentation/home/controllers/home_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context, HomeController controller) {
    controller.initFilterModal();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final sortOptions = [
      'Relevance',
      'Price low to high',
      'Price high to low',
    ];

    final sizeOptions = ['S', 'M', 'L', 'XL', 'XXL'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 30,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Filters & Close 'X' Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 24,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 2. Sort By Section Title
              Text(
                'Sort By',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Sort By Options (Height 36, width fits text, corner radius 10)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    children: sortOptions.map((option) {
                      final isSelected = controller.tempSort.value == option;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.tempSort.value = option;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1A1A1A)
                                    : const Color(0xFFE6E6E6),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              option,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // 4. Divider Line (weight 1, color E6E6E6)
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFFE6E6E6),
              ),
              const SizedBox(height: 20),

              // 5. Price Section Title & Range Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Obx(() {
                    final values = controller.tempPriceRange.value;
                    return Text(
                      '\$${values.start.round()} - \$${values.end.round()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),

              // 6. Price Range Slider (2 ellipse thumbs, container track height 4)
              Obx(() {
                return SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: const Color(0xFF1A1A1A),
                    inactiveTrackColor: const Color(0xFFE6E6E6),
                    rangeThumbShape: const CustomRangeSliderThumbShape(
                      radius: 10,
                      fillColor: Color(0xFFFFFFFF),
                      strokeColor: Color(0xFFCCCCCC),
                      strokeWidth: 1,
                    ),
                    overlayColor: const Color(0x1F1A1A1A),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 18,
                    ),
                    rangeTrackShape: const RectangularRangeSliderTrackShape(),
                  ),
                  child: RangeSlider(
                    values: controller.tempPriceRange.value,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    onChanged: (RangeValues newValues) {
                      controller.tempPriceRange.value = newValues;
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),

              // 7. Size Section with Dropdown at the End
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Size',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Obx(() {
                    return Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE6E6E6),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.tempSize.value,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          elevation: 2,
                          borderRadius: BorderRadius.circular(10),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.tempSize.value = newValue;
                            }
                          },
                          items: sizeOptions.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // 8. Apply Filter Button (Height 54)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilterModal();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Apply Filter',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRangeSliderThumbShape extends RangeSliderThumbShape {
  final double radius;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const CustomRangeSliderThumbShape({
    this.radius = 10,
    this.fillColor = const Color(0xFFFFFFFF),
    this.strokeColor = const Color(0xFFCCCCCC),
    this.strokeWidth = 1,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Path shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(
      shadowPath,
      Colors.black.withValues(alpha: 0.08),
      3,
      true,
    );

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    final Paint strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, strokePaint);
  }
}
