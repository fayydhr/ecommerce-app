import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/core/widgets/app_snackbar.dart';
import 'package:ecommerce/data/datasources/user_store_datasource.dart';
import 'package:ecommerce/domain/entities/address_entity.dart';
import 'package:ecommerce/domain/entities/cart_item_entity.dart';
import 'package:ecommerce/presentation/home/controllers/home_controller.dart';

class CheckoutController extends GetxController {
  final UserStoreDataSource userStoreDataSource;

  CheckoutController({required this.userStoreDataSource});

  final RxList<CartItemEntity> cartItems = <CartItemEntity>[].obs;
  final RxString selectedPaymentMethod = 'Card'.obs; // 'Card', 'Cash', 'Pay'
  final TextEditingController promoController = TextEditingController();
  final RxDouble discount = 0.0.obs;
  final RxBool isPlacingOrder = false.obs;

  // Addresses
  final RxList<AddressEntity> addresses = <AddressEntity>[
    const AddressEntity(
      id: '1',
      title: 'Home',
      fullAddress: '925 S Chugach St #APT 10, Alaska 99645',
      isDefault: true,
    ),
    const AddressEntity(
      id: '2',
      title: 'Office',
      fullAddress: '4517 Washington Ave. Manchester, Kentucky 39495',
      isDefault: false,
    ),
    const AddressEntity(
      id: '3',
      title: 'Apartment',
      fullAddress: '2464 Royal Ln. Mesa, New Jersey 45463',
      isDefault: false,
    ),
  ].obs;

  late final Rx<AddressEntity> selectedAddress = addresses.first.obs;

  void selectAddress(AddressEntity address) {
    selectedAddress.value = address;
  }

  void addAddress(String title, String fullAddress) {
    final newAddress = AddressEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      fullAddress: fullAddress,
    );
    addresses.add(newAddress);
    selectedAddress.value = newAddress;
  }

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await userStoreDataSource.getCartItems();
    cartItems.assignAll(items);
  }

  double get subtotal {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get vat => 0.0;
  double get shippingFee => 0.0;

  double get total {
    final t = subtotal + vat + shippingFee - discount.value;
    return t > 0 ? t : 0.0;
  }

  void selectPayment(String method) {
    selectedPaymentMethod.value = method;
  }

  void applyPromo() {
    final code = promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'DISCOUNT10' || code == 'PROMO10') {
      discount.value = subtotal * 0.10;
      AppSnackbar.showSuccess(
        title: 'Promo Applied',
        message: '10% discount applied!',
      );
    } else {
      AppSnackbar.showError(
        title: 'Invalid Code',
        message: 'Promo code is not valid.',
      );
    }
  }

  Future<void> placeOrder() async {
    isPlacingOrder.value = true;
    await userStoreDataSource.clearCart();
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().loadCart();
    }
    isPlacingOrder.value = false;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Order Placed!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order has been placed successfully. Thank you for shopping with us!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF808080),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.back(); // back from checkout to home/cart
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
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
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    promoController.dispose();
    super.onClose();
  }
}
