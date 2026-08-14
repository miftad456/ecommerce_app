import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
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

class _ProductFormScreenState
    extends State<ProductFormScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor =
      Color(0xFF6750A4);

  static const Color primaryDark =
      Color(0xFF4F378B);

  static const Color backgroundColor =
      Color(0xFFF8F7FC);

  static const Color textDark =
      Color(0xFF1D1B20);

  static const Color textGrey =
      Color(0xFF79747E);

  static const Color dangerColor =
      Color(0xFFB3261E);

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  // ============================================================
  // EDITING
  // ============================================================

  bool get isEditing {
    return widget.product != null;
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();

    super.dispose();
  }

  // ============================================================
  // SHOW ERROR
  // ============================================================

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dangerColor,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SAVE PRODUCT
  // ============================================================

  void saveProduct() {
    final title =
        titleController.text.trim();

    final description =
        descriptionController.text.trim();

    final priceText =
        priceController.text.trim();

    // ==========================================================
    // VALIDATION
    // ==========================================================

    if (title.isEmpty) {
      showError(
        'Please enter a product name.',
      );
      return;
    }

    if (description.isEmpty) {
      showError(
        'Please enter a product description.',
      );
      return;
    }

    if (priceText.isEmpty) {
      showError(
        'Please enter a product price.',
      );
      return;
    }

    // ==========================================================
    // CONVERT PRICE
    // ==========================================================

    final price =
        double.tryParse(priceText);

    if (price == null || price < 0) {
      showError(
        'Please enter a valid price.',
      );
      return;
    }

    // ==========================================================
    // CREATE PRODUCT
    // ==========================================================

    final product = Product(
      id: widget.product?.id ??
          DateTime.now()
              .millisecondsSinceEpoch,
      name: title,
      description: description,
      imageUrl:
          widget.product?.imageUrl ?? '',
      price: price,
    );

    // ==========================================================
    // DISPATCH BLOC EVENT
    // ==========================================================

    if (isEditing) {
      context.read<ProductBloc>().add(
            UpdateProductEvent(product),
          );
    } else {
      context.read<ProductBloc>().add(
            AddProductEvent(product),
          );
    }
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required String hintText,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF9B96A2),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: primaryColor,
        size: 21,
      ),
      prefixText: prefixText,
      prefixStyle: const TextStyle(
        color: primaryDark,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFFE8E3ED),
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Color(0xFFE8E3ED),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget sectionLabel({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: textGrey,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORM HEADER
  // ============================================================

  Widget formHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6750A4),
            Color(0xFF4F378B),
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336750A4),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              isEditing
                  ? Icons.edit_rounded
                  : Icons.add_shopping_cart_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'EDIT PRODUCT'
                      : 'NEW PRODUCT',
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.72),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEditing
                      ? 'Update your product'
                      : 'Create something new',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Keep your product information up to date.'
                      : 'Add your product details to ShopEasy.',
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.75),
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE PREVIEW
  // ============================================================

  Widget pricePreview() {
    final price =
        double.tryParse(
      priceController.text.trim(),
    );

    if (price == null) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 200),
      margin:
          const EdgeInsets.only(top: 10),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EEFF),
        borderRadius:
            BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE3D9FF),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.sell_outlined,
            size: 18,
            color: primaryColor,
          ),
          const SizedBox(width: 8),
          const Text(
            'Current price',
            style: TextStyle(
              color: textGrey,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: primaryDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
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
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        // ========================================================
        // SUCCESS
        // ========================================================

        if (state is ProductOperationSuccess) {
          Navigator.pop(context);
          return;
        }

        // ========================================================
        // ERROR
        // ========================================================

        if (state is ProductError) {
          showError(state.message);
          return;
        }
      },
      child: PhoneFrame(
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
            title: Text(
              isEditing
                  ? 'Edit Product'
                  : 'Add Product',
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
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
                  formHeader(),

                  const SizedBox(height: 25),

                  // =================================================
                  // PRODUCT NAME
                  // =================================================

                  sectionLabel(
                    title: 'Product Name',
                    subtitle:
                        'Give your product a clear name.',
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        titleController,
                    textCapitalization:
                        TextCapitalization
                            .words,
                    decoration:
                        inputDecoration(
                      hintText:
                          'e.g. Gaming Laptop',
                      icon:
                          Icons.shopping_bag_outlined,
                    ),
                  ),

                  const SizedBox(height: 21),

                  // =================================================
                  // DESCRIPTION
                  // =================================================

                  sectionLabel(
                    title: 'Description',
                    subtitle:
                        'Tell customers what makes this product special.',
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        descriptionController,
                    textCapitalization:
                        TextCapitalization
                            .sentences,
                    maxLines: 5,
                    minLines: 5,
                    decoration:
                        inputDecoration(
                      hintText:
                          'Describe your product...',
                      icon:
                          Icons.description_outlined,
                    ).copyWith(
                      alignLabelWithHint:
                          true,
                    ),
                  ),

                  const SizedBox(height: 21),

                  // =================================================
                  // PRICE
                  // =================================================

                  sectionLabel(
                    title: 'Price',
                    subtitle:
                        'Set the selling price for your product.',
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller:
                        priceController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration:
                        inputDecoration(
                      hintText:
                          'e.g. 1500.00',
                      icon:
                          Icons.attach_money,
                    ),
                  ),

                  pricePreview(),

                  const SizedBox(height: 28),

                  // =================================================
                  // INFORMATION CARD
                  // =================================================

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        17,
                      ),
                      border: Border.all(
                        color:
                            const Color(
                          0xFFE8E3ED,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFF0EBFF,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color:
                                primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Product information',
                                style:
                                    TextStyle(
                                  color:
                                      textDark,
                                  fontSize: 12.5,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Make sure your product name, '
                                'description, and price are accurate '
                                'before saving.',
                                style:
                                    TextStyle(
                                  color:
                                      textGrey,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // =================================================
                  // SAVE BUTTON
                  // =================================================

                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      final isLoading =
                          state is ProductLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed:
                              isLoading
                                  ? null
                                  : saveProduct,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color:
                                        Colors.white,
                                  ),
                                )
                              : Icon(
                                  isEditing
                                      ? Icons
                                          .save_outlined
                                      : Icons.add_rounded,
                                  size: 21,
                                ),
                          label: Text(
                            isLoading
                                ? 'Saving...'
                                : isEditing
                                    ? 'Update Product'
                                    : 'Add Product',
                            style:
                                const TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                primaryColor,
                            foregroundColor:
                                Colors.white,
                            disabledBackgroundColor:
                                primaryColor
                                    .withValues(
                              alpha: 0.55,
                            ),
                            elevation: 5,
                            shadowColor:
                                const Color(
                              0x446750A4,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                17,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 11),

                  // =================================================
                  // CANCEL
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style:
                          TextButton.styleFrom(
                        foregroundColor:
                            textGrey,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}