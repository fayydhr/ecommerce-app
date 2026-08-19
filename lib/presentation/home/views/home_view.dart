import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/domain/entities/product_entity.dart';
import 'package:ecommerce/presentation/home/controllers/home_controller.dart';
import 'package:ecommerce/presentation/home/widgets/filter_bottom_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          switch (controller.currentNavIndex.value) {
            case 0:
              return _buildHomeTab(context);
            case 1:
              return _buildSearchTab();
            case 2:
              return _buildSavedTab();
            case 3:
              return _buildCartTab();
            case 4:
              return _buildAccountTab();
            default:
              return _buildHomeTab(context);
          }
        }),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==================== BOTTOM NAVIGATION BAR ====================
  Widget _buildBottomNavigationBar() {
    final navItems = [
      {'icon': 'assets/icons/home.svg', 'label': 'Home'},
      {'icon': 'assets/icons/Search.svg', 'label': 'Search'},
      {'icon': 'assets/icons/heart.svg', 'label': 'Saved'},
      {'icon': 'assets/icons/cart.svg', 'label': 'Cart'},
      {'icon': 'assets/icons/user.svg', 'label': 'Account'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE6E6E6),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = controller.currentNavIndex.value == index;
                final activeColor = const Color(0xFF1A1A1A);
                final inactiveColor = const Color(0xFF999999);
                final currentColor = isSelected ? activeColor : inactiveColor;

                return GestureDetector(
                  onTap: () => controller.changeNavIndex(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SVG Icon with dynamic ColorFilter
                        SvgPicture.asset(
                          item['icon']!,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            currentColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Label: General Sans medium 12 line height 120%
                        Text(
                          item['label']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: currentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== TAB 0: HOME / DISCOVER ====================
  Widget _buildHomeTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadCategories();
        await controller.loadProducts();
        await controller.loadWishlist();
        await controller.loadCart();
      },
      color: const Color(0xFF1A1A1A),
      child: CustomScrollView(
        slivers: [
          // 1. Top Header: Discover & Notif Icon
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.notifications),
                    child: SvgPicture.asset(
                      'assets/icons/notif.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Search & Filter Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Search TextField
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE6E6E6),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: const Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for clothes...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: const Color(0xFF808080),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              'assets/icons/Search.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Black Filter Button
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/filter.svg',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () {
                        FilterBottomSheet.show(context, controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 3. Category Filter Box (Horizontal Chips)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: Obx(
                () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedCategory.value == category;

                      return GestureDetector(
                        onTap: () => controller.selectCategory(category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFE6E6E6),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _formatCategoryName(category),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF808080),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 4. Product 2x2 Grid (w: 161, h: 224, image container: 161x174)
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A1A1A),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            }

            if (controller.displayProducts.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Color(0xFF808080),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 161 / 238,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = controller.displayProducts[index];
                    return _buildProductCard(product);
                  },
                  childCount: controller.displayProducts.length,
                ),
              ),
            );
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetail, arguments: product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container (161 x 174, border radius 12, background #F6F6F6, with Heart Icon)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Product Image
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image_rounded,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                  ),

                  // Love / Favorite Icon Button in top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final isFav = controller.isFavorite(product.id);
                      return GestureDetector(
                        onTap: () => controller.toggleFavorite(product),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18,
                            color: isFav
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Product Title: General Sans semibold 16 line height 140%
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 2),

          // Product Price Subtitle: General Sans medium 12 #808080
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF808080),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TAB 1: SEARCH ====================
  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE6E6E6)),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products, brands...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF808080),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    'assets/icons/Search.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.displayProducts.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFFE6E6E6),
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  final product = controller.displayProducts[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => Get.toNamed(
                      Routes.productDetail,
                      arguments: product,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    subtitle: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF808080),
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF808080),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TAB 2: SAVED / WISHLIST ====================
  Widget _buildSavedTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Items',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.wishlistProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/lovekosng.svg',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Saved Items!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You don’t have any saved items. Go to home and add some.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: controller.wishlistProducts.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFFE6E6E6),
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  final product = controller.wishlistProducts[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => Get.toNamed(
                      Routes.productDetail,
                      arguments: product,
                    ),
                    leading: Container(
                      width: 54,
                      height: 54,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    subtitle: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF808080),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFEF4444),
                        size: 22,
                      ),
                      onPressed: () => controller.toggleFavorite(product),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==================== TAB 3: CART ====================
  Widget _buildCartTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Cart',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.cartItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/mycartkosng.svg',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Your Cart Is Empty!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'When you add products, they’ll appear here.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: controller.cartItems.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFFE6E6E6),
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Row(
                    children: [
                      // Product Image
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Size: ${item.size}  •  \$${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF808080),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity Selector (- Qty +)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE6E6E6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () =>
                                  controller.updateCartQuantity(item.id, -1),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Icon(Icons.remove, size: 16),
                              ),
                            ),
                            Text(
                              '${item.quantity}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  controller.updateCartQuantity(item.id, 1),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          // Total Price & Checkout Bar
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                const Divider(color: Color(0xFFE6E6E6), thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF808080),
                            ),
                          ),
                          Text(
                            '\$${controller.cartTotalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Checkout action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ==================== TAB 4: ACCOUNT ====================
  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6E6E6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentUser.value?.displayName.isNotEmpty ==
                                  true
                              ? controller.currentUser.value!.displayName
                              : 'User',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.currentUser.value?.email ??
                              'user@example.com',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: const Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategoryName(String raw) {
    if (raw == 'All') return 'All';
    if (raw == "men's clothing") return "Men's Clothing";
    if (raw == "women's clothing") return "Women's Clothing";
    if (raw == 'jewelery') return 'Jewelry';
    if (raw == 'electronics') return 'Electronics';
    return raw.capitalizeFirst ?? raw;
  }
}
