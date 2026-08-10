
import 'package:flutter/material.dart';

import '../../data/datasources/product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../widgets/phone_frame.dart';

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

// ============================================================
// HOME STATE
// ============================================================

class _HomeScreenState extends State<HomeScreen> {
  // ==========================================================
  // DATA / DOMAIN DEPENDENCIES
  // ==========================================================

  late final ProductDatasource datasource;

  late final ProductRepositoryImpl repository;

  late final ViewAllProducts viewAllProducts;

  late final CreateProduct createProduct;

  late final UpdateProduct updateProduct;

  late final DeleteProduct deleteProduct;

  // ==========================================================
  // PRODUCTS
  // ==========================================================

  List<Product> products = [];

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    // --------------------------------------------------------
    // Create our dependencies.
    //
    // Later we can move this to dependency injection.
    // For now we keep it simple.
    // --------------------------------------------------------

    datasource = ProductDatasource();

    repository =
        ProductRepositoryImpl(datasource);

    viewAllProducts =
        ViewAllProducts(repository);

    createProduct =
        CreateProduct(repository);

    updateProduct =
        UpdateProduct(repository);

    deleteProduct =
        DeleteProduct(repository);

    // --------------------------------------------------------
    // Load products.
    // --------------------------------------------------------

    loadProducts();
  }

  // ==========================================================
  // LOAD PRODUCTS
  // ==========================================================

  Future<void> loadProducts() async {
    final result =
        await viewAllProducts();

    result.fold(
      (failure) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(failure),
          ),
        );
      },
      (loadedProducts) {
        if (!mounted) return;

        setState(() {
          products = loadedProducts;
        });
      },
    );
  }

  // ==========================================================
  // ADD PRODUCT
  // ==========================================================

  Future<void> addProduct() async {
    final result =
        await Navigator.pushNamed(
      context,
      '/product-form',
    );

    if (result is Product) {
      final createResult =
          await createProduct(result);

      createResult.fold(
        (failure) {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(failure),
            ),
          );
        },
        (_) {
          loadProducts();
        },
      );
    }
  }

  // ==========================================================
  // OPEN PRODUCT
  // ==========================================================

  Future<void> openProduct(
    Product product,
  ) async {
    final result =
        await Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );

    // --------------------------------------------------------
    // RECEIVE RESULT
    // --------------------------------------------------------

    if (result is Map<String, dynamic>) {
      final action =
          result['action'];

      // ======================================================
      // UPDATE
      // ======================================================

      if (action == 'update') {
        final updatedProduct =
            result['product'] as Product;

        final updateResult =
            await updateProduct(
          updatedProduct,
        );

        updateResult.fold(
          (failure) {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(failure),
              ),
            );
          },
          (_) {
            loadProducts();
          },
        );
      }

      // ======================================================
      // DELETE
      // ======================================================

      if (action == 'delete') {
        final productId =
            result['productId'] as int;

        final deleteResult =
            await deleteProduct(
          productId,
        );

        deleteResult.fold(
          (failure) {
            if (!mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(failure),
              ),
            );
          },
          (_) {
            loadProducts();
          },
        );
      }
    }
  }

  // ==========================================================
  // PRODUCT CARD
  // ==========================================================

  Widget productCard(
    Product product,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: () {
          openProduct(product);
        },
        child: Padding(
          padding:
              const EdgeInsets.all(14),
          child: Row(
            children: [
              // ------------------------------------------------
              // PRODUCT IMAGE AREA
              // ------------------------------------------------

              Container(
                width: 80,
                height: 80,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFF1EFF7),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Icon(
                  Icons
                      .shopping_bag_outlined,
                  size: 38,
                  color:
                      Color(0xFF6750A4),
                ),
              ),

              const SizedBox(width: 14),

              // ------------------------------------------------
              // PRODUCT INFORMATION
              // ------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      product.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors
                            .grey.shade600,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF6750A4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ------------------------------------------------
              // ARROW
              // ------------------------------------------------

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return PhoneFrame(
      child: Scaffold(
        // ------------------------------------------------------
        // APP BAR
        // ------------------------------------------------------

        appBar: AppBar(
          title: const Text(
            'ShopEasy',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons
                    .shopping_cart_outlined,
              ),
            ),
          ],
        ),

        // ------------------------------------------------------
        // BODY
        // ------------------------------------------------------

        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),

                // ------------------------------------------------
                // GREETING
                // ------------------------------------------------

                const Text(
                  'Find your products',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  'Everything you need in one place.',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ------------------------------------------------
                // SEARCH
                // ------------------------------------------------

                TextField(
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Search products...',
                    prefixIcon:
                        Icon(Icons.search),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ------------------------------------------------
                // CATEGORY
                // ------------------------------------------------

                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                // ------------------------------------------------
                // PRODUCT LIST
                // ------------------------------------------------

                Expanded(
                  child: products.isEmpty
                      ? const Center(
                          child: Text(
                            'No products yet.',
                          ),
                        )
                      : ListView.builder(
                          padding:
                              EdgeInsets.zero,
                          itemCount:
                              products.length,
                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            return productCard(
                              products[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),

        // ------------------------------------------------------
        // ADD PRODUCT
        // ------------------------------------------------------

        floatingActionButton:
            FloatingActionButton(
          onPressed: addProduct,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

