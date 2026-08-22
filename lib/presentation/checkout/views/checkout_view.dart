import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/presentation/checkout/controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Divider Line (E6E6E6 weight 1)
            Container(
              height: 1,
              color: const Color(0xFFE6E6E6),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ==================== DELIVERY ADDRESS ====================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.address),
                          child: Text(
                            'Change',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Address Card / Row (Entire area clickable)
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.address),
                      behavior: HitTestBehavior.opaque,
                      child: Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFF999999),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.selectedAddress.value.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.selectedAddress.value.fullAddress,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF808080),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Color(0xFF999999),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider Line
                    Container(
                      height: 1,
                      color: const Color(0xFFE6E6E6),
                    ),
                    const SizedBox(height: 20),

                    // ==================== PAYMENT METHOD ====================
                    Text(
                      'Payment Method',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Selection Buttons (Card, Cash, Pay)
                    Obx(
                      () => Row(
                        children: [
                          _buildPaymentOption(
                            id: 'Card',
                            label: 'Card',
                            icon: Icons.credit_card_rounded,
                          ),
                          const SizedBox(width: 12),
                          _buildPaymentOption(
                            id: 'Cash',
                            label: 'Cash',
                            icon: Icons.payments_outlined,
                          ),
                          const SizedBox(width: 12),
                          _buildPaymentOption(
                            id: 'Pay',
                            label: 'Pay',
                            icon: Icons.apple,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card Detail Container (white, stroke 000000 weight 1, VISA logo, number, pencil)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // VISA Logo Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFE6E6E6),
                              ),
                            ),
                            child: Text(
                              'VISA',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF1A1A1A),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Card Number
                          Expanded(
                            child: Text(
                              '**** **** **** 2512',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1A1A1A),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          // Pencil Edit Icon
                          GestureDetector(
                            onTap: () {
                              // Edit card action
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider Line
                    Container(
                      height: 1,
                      color: const Color(0xFFE6E6E6),
                    ),
                    const SizedBox(height: 20),

                    // ==================== ORDER SUMMARY ====================
                    Text(
                      'Order Summary',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      final subtotal = controller.subtotal;
                      final vat = controller.vat;
                      final shippingFee = controller.shippingFee;
                      final total = controller.total;

                      return Column(
                        children: [
                          // Subtotal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // VAT (%)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'VAT (%)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '\$${vat.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Shipping fee
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shipping fee',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '\$${shippingFee.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Divider Line
                          Container(
                            height: 1,
                            color: const Color(0xFFE6E6E6),
                          ),
                          const SizedBox(height: 16),

                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // Promo Code Section (Input box + separate Add button)
                    Row(
                      children: [
                        // Promo Code TextField (h: 52, stroke 000000 weight 1 from textfield border, radius 10)
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: TextField(
                              controller: controller.promoController,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: const Color(0xFF1A1A1A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter promo code',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: const Color(0xFF808080),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Add Button (w: 84, h: 52, black, radius 10)
                        SizedBox(
                          width: 84,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.applyPromo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A1A),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 65),

                    // Place Order Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isPlacingOrder.value
                              ? null
                              : controller.placeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isPlacingOrder.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Place Order',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Color(0xFF1A1A1A),
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Checkout',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 16),
          icon: SvgPicture.asset(
            'assets/icons/notif.svg',
            width: 26,
            height: 26,
          ),
          onPressed: () => Get.toNamed(Routes.notifications),
        ),
      ],
    );
  }

  // ==================== PAYMENT OPTION CHIP ====================
  Widget _buildPaymentOption({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = controller.selectedPaymentMethod.value == id;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectPayment(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFE6E6E6),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
