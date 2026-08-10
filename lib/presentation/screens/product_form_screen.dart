
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/phone_frame.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({
    super.key,
    this.product,
  });

  @override
  State<ProductFormScreen> createState() =>
      _ProductFormScreenState();
}

// ============================================================
// STATE
// ============================================================

class _ProductFormScreenState
    extends State<ProductFormScreen> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final titleController = TextEditingController();

  final descriptionController =
      TextEditingController();

  final priceController = TextEditingController();

  // ==========================================================
  // EDITING?
  // ==========================================================

  bool get isEditing {
    return widget.product != null;
  }

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      titleController.text =
          widget.product!.name;

      descriptionController.text =
          widget.product!.description;

      priceController.text =
          widget.product!.price.toString();
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    titleController.dispose();

    descriptionController.dispose();

    priceController.dispose();

    super.dispose();
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  void saveProduct() {
    final title =
        titleController.text.trim();

    final description =
        descriptionController.text.trim();

    final priceText =
        priceController.text.trim();

    // --------------------------------------------------------
    // VALIDATION
    // --------------------------------------------------------

    if (title.isEmpty ||
        description.isEmpty ||
        priceText.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields.',
          ),
        ),
      );

      return;
    }

    // --------------------------------------------------------
    // CONVERT PRICE
    // --------------------------------------------------------

    final price =
        double.tryParse(priceText);

    if (price == null || price < 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid price.',
          ),
        ),
      );

      return;
    }

    // ========================================================
    // EDIT
    // ========================================================

    if (isEditing) {
      final updatedProduct = Product(
        id: widget.product!.id,
        name: title,
        description: description,

        // Keep the existing image URL when editing.
        imageUrl: widget.product!.imageUrl,

        price: price,
      );

      Navigator.pop(
        context,
        updatedProduct,
      );

      return;
    }

    // ========================================================
    // CREATE
    // ========================================================

    final newProduct = Product(
      id: DateTime.now()
          .millisecondsSinceEpoch,

      name: title,

      description: description,

      // The original application doesn't have
      // an image URL input yet, so keep it empty.
      imageUrl: '',

      price: price,
    );

    Navigator.pop(
      context,
      newProduct,
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
          title: Text(
            isEditing
                ? 'Edit Product'
                : 'Add Product',
          ),
        ),

        // ------------------------------------------------------
        // BODY
        // ------------------------------------------------------

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------

                Text(
                  isEditing
                      ? 'Update your product'
                      : 'Create a new product',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isEditing
                      ? 'Change the information below.'
                      : 'Enter the product information below.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                // ------------------------------------------------
                // PRODUCT NAME
                // ------------------------------------------------

                const Text(
                  'Product Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'e.g. Gaming Laptop',
                    prefixIcon: Icon(
                      Icons.shopping_bag_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // DESCRIPTION
                // ------------------------------------------------

                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller:
                      descriptionController,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Describe your product...',
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // PRICE
                // ------------------------------------------------

                const Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    hintText: 'e.g. 1500',
                    prefixIcon: Icon(
                      Icons.attach_money,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ------------------------------------------------
                // SAVE BUTTON
                // ------------------------------------------------

                ElevatedButton.icon(
                  onPressed: saveProduct,
                  icon: Icon(
                    isEditing
                        ? Icons.save_outlined
                        : Icons.add,
                  ),
                  label: Text(
                    isEditing
                        ? 'Update Product'
                        : 'Add Product',
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

