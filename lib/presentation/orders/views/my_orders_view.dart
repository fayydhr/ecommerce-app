import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/domain/entities/order_item_entity.dart';
import 'package:ecommerce/presentation/orders/controllers/orders_controller.dart';

class MyOrdersView extends GetView<OrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          'My Orders',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Divider Line
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFE6E6E6),
            ),
            const SizedBox(height: 20),

            // Tab Switcher Container (h: 54, bg: E6E6E6, radius: 10, padding: 25)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 54,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  final activeTab = controller.selectedTabIndex.value;
                  return Row(
                    children: [
                      // On Going Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setTab(0),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 38,
                            decoration: BoxDecoration(
                              color: activeTab == 0
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: activeTab == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ongoing',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: activeTab == 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: activeTab == 0
                                    ? const Color(0xFF1A1A1A)
                                    : const Color(0xFF999999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Completed Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setTab(1),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 38,
                            decoration: BoxDecoration(
                              color: activeTab == 1
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: activeTab == 1
                                  ? [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Completed',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: activeTab == 1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: activeTab == 1
                                    ? const Color(0xFF1A1A1A)
                                    : const Color(0xFF999999),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Order Content Section
            Expanded(
              child: Obx(() {
                final orders = controller.currentFilteredOrders;

                if (orders.isEmpty) {
                  return _buildEmptyState(controller.selectedTabIndex.value == 0);
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final item = orders[index];
                    return _buildOrderItemCard(item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItemEntity item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Container
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              item.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image_rounded,
                color: Color(0xFF808080),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Middle Column: Title, Size, Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF808080),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Right Column: Status & Track Order Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status Badge (E6E6E6 radius 6)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Track Order Button (1A1A1A radius 6)
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'Order Status',
                    '${item.title} is currently ${item.status}.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF1A1A1A),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 10,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Track Order',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isOngoing) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/boxduoton.svg',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 24),
            Text(
              isOngoing ? 'No Ongoing Orders!' : 'No Completed Orders!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isOngoing
                  ? 'You don’t have any ongoing orders at this time.'
                  : 'You haven’t completed any orders yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF808080),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
