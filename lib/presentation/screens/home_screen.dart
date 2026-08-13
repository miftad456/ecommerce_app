
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_info.dart';
import '../../data/datasources/product_local_datasource_impl.dart';
import '../../data/datasources/product_remote_datasource_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../widgets/phone_frame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFF6750A4);
  static const Color primaryDark = Color(0xFF4F378B);
  static const Color backgroundColor = Color(0xFFF8F7FC);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1D1B20);
  static const Color textGrey = Color(0xFF79747E);

  // ============================================================
  // REPOSITORY / USE CASES
  // ============================================================

  late final NetworkInfo networkInfo;

  late final ProductLocalDataSourceImpl localDataSource;

  late final ProductRemoteDataSourceImpl remoteDataSource;

  late final ProductRepositoryImpl repository;

  late final ViewAllProducts viewAllProducts;

  late final CreateProduct createProduct;

  late final UpdateProduct updateProduct;

  late final DeleteProduct deleteProduct;

  // ============================================================
  // STATE
  // ============================================================

  List<Product> products = [];

  bool isLoading = true;

  String searchQuery = '';

  String selectedCategory = 'All';

  final TextEditingController searchController =
      TextEditingController();

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<String> categories = [
    'All',
    'Laptops',
    'Phones',
    'Audio',
    'Accessories',
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    searchController.addListener(
      _onSearchChanged,
    );

    _initializeDependenciesAndLoad();
  }

  Future<void> _initializeDependenciesAndLoad() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final dio = Dio();
    final internetConnection = InternetConnection();

    networkInfo = NetworkInfoImpl(internetConnection);
    localDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    remoteDataSource = ProductRemoteDataSourceImpl(
      dio: dio,
      baseUrl: 'https://dummyjson.com',
    );

    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    viewAllProducts = ViewAllProducts(repository);
    createProduct = CreateProduct(repository);
    updateProduct = UpdateProduct(repository);
    deleteProduct = DeleteProduct(repository);

    await loadProducts();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text
          .trim()
          .toLowerCase();
    });
  }

  // ============================================================
  // FILTERED PRODUCTS
  // ============================================================

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery) ||
          product.description
              .toLowerCase()
              .contains(searchQuery);

      if (selectedCategory == 'All') {
        return matchesSearch;
      }

      final productName = product.name.toLowerCase();
      final productDescription =
          product.description.toLowerCase();

      final category = selectedCategory.toLowerCase();

      final matchesCategory =
          productName.contains(category) ||
          productDescription.contains(category);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
    });

    final result = await viewAllProducts();

    result.fold(
      (failure) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFB3261E),
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
                  child: Text(failure),
                ),
              ],
            ),
          ),
        );
      },
      (loadedProducts) {
        if (!mounted) return;

        setState(() {
          products = loadedProducts;
          isLoading = false;
        });
      },
    );
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<void> addProduct() async {
    final result = await Navigator.pushNamed(
      context,
      '/product-form',
    );

    if (result is! Product) {
      return;
    }

    final createResult = await createProduct(result);

    createResult.fold(
      (failure) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFB3261E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: Text(failure),
          ),
        );
      },
      (_) {
        loadProducts();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  'Product added successfully',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // OPEN PRODUCT
  // ============================================================

  Future<void> openProduct(
    Product product,
  ) async {
    final result = await Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );

    if (result is! Map<String, dynamic>) {
      return;
    }

    final action = result['action'];

    // ==========================================================
    // UPDATE
    // ==========================================================

    if (action == 'update') {
      final updatedProduct =
          result['product'] as Product;

      final updateResult = await updateProduct(
        updatedProduct,
      );

      updateResult.fold(
        (failure) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(failure),
            ),
          );
        },
        (_) {
          loadProducts();
        },
      );
    }

    // ==========================================================
    // DELETE
    // ==========================================================

    if (action == 'delete') {
      final productId =
          result['productId'] as int;

      final deleteResult = await deleteProduct(
        productId,
      );

      deleteResult.fold(
        (failure) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
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

  // ============================================================
  // PRODUCT ICON
  // ============================================================

  IconData productIcon(Product product) {
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
  // PRODUCT CARD
  // ============================================================

  Widget productCard(
    Product product,
  ) {
    return GestureDetector(
      onTap: () {
        openProduct(product);
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE9E5F0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ------------------------------------------------
              // PRODUCT IMAGE / ICON
              // ------------------------------------------------

              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF0EBFF),
                      Color(0xFFE7DFFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  productIcon(product),
                  size: 42,
                  color: primaryColor,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textDark,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: textGrey,
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Text(
                      product.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF2EEFF),
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: primaryDark,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.star_rounded,
                          size: 17,
                          color: Color(0xFFFFB300),
                        ),

                        const SizedBox(width: 3),

                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CHIP
  // ============================================================

  Widget categoryChip(
    String category,
  ) {
    final selected =
        selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor
              : Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? primaryColor
                : const Color(0xFFE6E1EB),
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x226750A4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: selected
                ? Colors.white
                : textDark,
            fontSize: 12.5,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FEATURED BANNER
  // ============================================================

  Widget featuredBanner() {
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
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.16),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SHOP SMART',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Everything you need.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Discover great products '
                  'at great prices.',
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.78),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              size: 38,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: Color(0xFFF0EBFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 42,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            searchQuery.isNotEmpty
                ? 'No products found'
                : 'No products yet',
            style: const TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            searchQuery.isNotEmpty
                ? 'Try another search term.'
                : 'Add your first product to get started.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: addProduct,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Product',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // LOADING STATE
  // ============================================================

  Widget loadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final visibleProducts =
        filteredProducts;

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
          titleSpacing: 20,

          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF6750A4),
                      Color(0xFF8A6BD1),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'ShopEasy',
                style: TextStyle(
                  color: textDark,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          actions: [
            Container(
              margin:
                  const EdgeInsets.only(
                right: 16,
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
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 20,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: SafeArea(
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: loadProducts,
            child: CustomScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good to see you 👋',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Find what you love.',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 27,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // SEARCH
                        Container(
                          decoration:
                              BoxDecoration(
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
                            boxShadow:
                                const [
                              BoxShadow(
                                color:
                                    Color(
                                  0x0A000000,
                                ),
                                blurRadius: 12,
                                offset:
                                    Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller:
                                searchController,
                            decoration:
                                const InputDecoration(
                              hintText:
                                  'Search products...',
                              hintStyle:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF9B96A2,
                                ),
                                fontSize: 13,
                              ),
                              prefixIcon:
                                  Icon(
                                Icons.search,
                                color:
                                    primaryColor,
                              ),
                              suffixIcon:
                                  Icon(
                                Icons.tune_rounded,
                                color:
                                    textGrey,
                              ),
                              border:
                                  InputBorder.none,
                              contentPadding:
                                  EdgeInsets
                                      .symmetric(
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // FEATURED BANNER
                        featuredBanner(),

                        const SizedBox(height: 22),

                        // CATEGORY TITLE
                        Row(
                          children: [
                            const Text(
                              'Categories',
                              style:
                                  TextStyle(
                                color:
                                    textDark,
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              '${products.length} products',
                              style:
                                  const TextStyle(
                                color:
                                    textGrey,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // CATEGORY CHIPS
                        SizedBox(
                          height: 40,
                          child:
                              ListView.separated(
                            scrollDirection:
                                Axis.horizontal,
                            itemCount:
                                categories.length,
                            separatorBuilder:
                                (_, _) =>
                                    const SizedBox(
                              width: 8,
                            ),
                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              return categoryChip(
                                categories[index],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // PRODUCTS HEADER
                        Row(
                          children: [
                            const Text(
                              'Popular products',
                              style:
                                  TextStyle(
                                color:
                                    textDark,
                                fontSize: 19,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            const Spacer(),

                            if (searchQuery
                                .isNotEmpty)
                              Text(
                                '${visibleProducts.length} found',
                                style:
                                    const TextStyle(
                                  color:
                                      textGrey,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // ------------------------------------------------
                // PRODUCTS
                // ------------------------------------------------

                if (isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: loadingState(),
                  )
                else if (visibleProducts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      child: emptyState(),
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      110,
                    ),
                    sliver:
                        SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          context,
                          index,
                        ) {
                          return productCard(
                            visibleProducts[
                                index],
                          );
                        },
                        childCount:
                            visibleProducts.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ======================================================
        // ADD PRODUCT BUTTON
        // ======================================================

        floatingActionButton:
            FloatingActionButton.extended(
          onPressed: addProduct,
          backgroundColor:
              primaryColor,
          foregroundColor:
              Colors.white,
          elevation: 5,
          icon: const Icon(
            Icons.add_rounded,
          ),
          label: const Text(
            'Add Product',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}

