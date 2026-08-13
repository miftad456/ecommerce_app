
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/phone_frame.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF6750A4);
  static const Color primaryDark = Color(0xFF4F378B);
  static const Color backgroundColor = Color(0xFFF8F7FC);
  static const Color textDark = Color(0xFF1D1B20);
  static const Color textGrey = Color(0xFF79747E);
  static const Color dangerColor = Color(0xFFB3261E);

  // ============================================================
  // STATE
  // ============================================================

  late Product product;

  @override
  void initState() {
    super.initState();

    product = widget.product;
  }

  // ============================================================
  // PRODUCT ICON
  // ============================================================

  IconData productIcon() {
    final text =
        '${product.name} ${product.description}'
            .toLowerCase();

    if (text.contains('laptop')) {
      return Icons.laptop_mac;
    }

    if (text.contains('phone')) {
      return Icons.phone_iphone;
    }

    if (text.contains('headphone') ||
        text.contains('audio')) {
      return Icons.headphones;
    }

    if (text.contains('watch')) {
      return Icons.watch_outlined;
    }

    if (text.contains('camera')) {
      return Icons.camera_alt_outlined;
    }

    return Icons.shopping_bag_outlined;
  }

  // ============================================================
  // EDIT PRODUCT
  // ============================================================

  Future<void> editProduct() async {
    final result = await Navigator.pushNamed(
      context,
      '/product-form',
      arguments: product,
    );

    if (result is Product) {
      if (!mounted) return;

      setState(() {
        product = result;
      });

      // Send updated product back to Home.
      Navigator.pop(
        context,
        {
          'action': 'update',
          'product': result,
        },
      );
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  void deleteProduct() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding:
              const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            10,
          ),
          contentPadding:
              const EdgeInsets.fromLTRB(
            24,
            0,
            24,
            10,
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBE9),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: dangerColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Delete Product?',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this product? '
            'This action cannot be undone.',
            style: TextStyle(
              color: textGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: textGrey,
              ),
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pop(
                  context,
                  {
                    'action': 'delete',
                    'productId': product.id,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dangerColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PRODUCT HERO
  // ============================================================

  Widget productHero() {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0EBFF),
            Color(0xFFE3D9FF),
          ],
        ),
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE5DDF2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x146750A4),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -45,
            right: -35,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Decorative circle
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.72),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A6750A4),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                productIcon(),
                size: 78,
                color: primaryColor,
              ),
            ),
          ),

          // Product type badge
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.82),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: primaryColor,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Available',
                    style: TextStyle(
                      color: primaryDark,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w700,
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

  // ============================================================
  // RATING CARD
  // ============================================================

  Widget ratingCard() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8E3ED),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D8),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB300),
              size: 23,
            ),
          ),

          const SizedBox(width: 10),

          const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '4.8 / 5.0',
                style: TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Excellent rating',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const Spacer(),

          const Text(
            '128 reviews',
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESCRIPTION CARD
  // ============================================================

  Widget descriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8E3ED),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBFF),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: primaryColor,
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Description',
                style: TextStyle(
                  color: textDark,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            product.description,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13.5,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      child: Scaffold(
        backgroundColor:
            backgroundColor,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          backgroundColor:
              backgroundColor,
          elevation: 0,
          surfaceTintColor:
              Colors.transparent,

          leading: Container(
            margin:
                const EdgeInsets.only(
              left: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    const Color(0xFFE8E3ED),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: textDark,
              ),
            ),
          ),

          title: const Text(
            'Product Details',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          centerTitle: true,

          actions: [
            Container(
              margin:
                  const EdgeInsets.only(
                right: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      const Color(0xFFE8E3ED),
                ),
              ),
              child: IconButton(
                onPressed: editProduct,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: SafeArea(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              35,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // HERO IMAGE
                // =================================================

                productHero(),

                const SizedBox(height: 22),

                // =================================================
                // PRODUCT TITLE
                // =================================================

                Text(
                  product.name,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 10),

                // =================================================
                // PRICE + RATING
                // =================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFF2EEFF),
                        borderRadius:
                            BorderRadius.circular(
                          11,
                        ),
                      ),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: primaryDark,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color:
                              Color(0xFFFFB300),
                          size: 20,
                        ),
                        SizedBox(width: 3),
                        Text(
                          '4.8',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // =================================================
                // RATING CARD
                // =================================================

                ratingCard(),

                const SizedBox(height: 18),

                // =================================================
                // DESCRIPTION
                // =================================================

                descriptionCard(),

                const SizedBox(height: 25),

                // =================================================
                // ACTIONS TITLE
                // =================================================

                const Text(
                  'Manage Product',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // EDIT BUTTON
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: editProduct,
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    label: const Text(
                      'Edit Product',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryColor,
                      foregroundColor:
                          Colors.white,
                      elevation: 4,
                      shadowColor:
                          const Color(
                        0x446750A4,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 11),

                // =================================================
                // DELETE BUTTON
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: deleteProduct,
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'Delete Product',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          dangerColor,
                      backgroundColor:
                          const Color(0xFFFFFBFA),
                      side: const BorderSide(
                        color:
                            Color(0xFFF1B8B2),
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
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

