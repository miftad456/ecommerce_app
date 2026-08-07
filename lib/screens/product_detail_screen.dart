import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/phone_frame.dart';

// ============================================================
// PRODUCT DETAIL SCREEN
// ============================================================

class ProductDetailScreen
    extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen>
      createState() =>
          _ProductDetailScreenState();
}

// ============================================================
// STATE
// ============================================================

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  late Product product;

  @override
  void initState() {
    super.initState();

    product = widget.product;
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  Future<void> editProduct() async {
    final result = await Navigator.pushNamed(
      context,
      '/product-form',
      arguments: product,
    );

    if (result is Product) {
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

  // ==========================================================
  // DELETE
  // ==========================================================

  void deleteProduct() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Product?',
          ),

          content: const Text(
            'Are you sure you want to delete this product?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(
                  this.context,
                  {
                    'action': 'delete',
                    'productId': product.id,
                  },
                );
              },

              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      child: Scaffold(
        // ------------------------------------------------------
        // APP BAR
        // ------------------------------------------------------

        appBar: AppBar(
          title: const Text(
            'Product Details',
          ),
        ),

        // ------------------------------------------------------
        // BODY
        // ------------------------------------------------------

        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ------------------------------------------------
                // PRODUCT IMAGE
                // ------------------------------------------------

                Container(
                  width: double.infinity,
                  height: 240,

                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFF1EFF7),

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),

                  child: const Icon(
                    Icons.shopping_bag_outlined,

                    size: 100,

                    color:
                        Color(0xFF6750A4),
                  ),
                ),

                const SizedBox(height: 25),

                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------

                Text(
                  product.title,

                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ------------------------------------------------
                // PRICE
                // ------------------------------------------------

                Text(
                  '\$${product.price.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(0xFF6750A4),
                  ),
                ),

                const SizedBox(height: 25),

                // ------------------------------------------------
                // DESCRIPTION TITLE
                // ------------------------------------------------

                const Text(
                  'Description',

                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // ------------------------------------------------
                // DESCRIPTION
                // ------------------------------------------------

                Text(
                  product.description,

                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color:
                        Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 35),

                // ------------------------------------------------
                // EDIT BUTTON
                // ------------------------------------------------

                ElevatedButton.icon(
                  onPressed: editProduct,

                  icon: const Icon(
                    Icons.edit_outlined,
                  ),

                  label: const Text(
                    'Edit Product',
                  ),
                ),

                const SizedBox(height: 12),

                // ------------------------------------------------
                // DELETE BUTTON
                // ------------------------------------------------

                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child:
                      OutlinedButton.icon(
                    onPressed:
                        deleteProduct,

                    icon: const Icon(
                      Icons.delete_outline,
                    ),

                    label: const Text(
                      'Delete Product',
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.red,

                      side:
                          const BorderSide(
                        color: Colors.red,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
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