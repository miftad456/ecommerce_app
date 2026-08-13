import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'product_local_datasource.dart';

const String cachedProductsKey = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static final List<ProductModel> _defaultProducts = [
    const ProductModel(
      id: 1,
      name: 'Gaming Laptop',
      description: 'Powerful laptop for work and gaming.',
      imageUrl: '',
      price: 1500,
    ),
    const ProductModel(
      id: 2,
      name: 'Smartphone',
      description: 'Modern smartphone with 5G support.',
      imageUrl: '',
      price: 800,
    ),
    const ProductModel(
      id: 3,
      name: 'Wireless Headphones',
      description: 'Comfortable headphones with clear sound.',
      imageUrl: '',
      price: 120,
    ),
  ];

  List<ProductModel> _getStoredProducts() {
    print('==================================================');
    print('LOCAL DATA SOURCE: Reading products from storage');
    print('==================================================');

    final jsonString = sharedPreferences.getString(cachedProductsKey);

    if (jsonString == null || jsonString.isEmpty) {
      print('LOCAL STORAGE: No cached products found');
      print('LOCAL STORAGE: Using default products');

      return List.from(_defaultProducts);
    }

    try {
      print('LOCAL STORAGE: Cached products found');
      print('LOCAL STORAGE: Decoding cached products');

      final decoded = jsonDecode(jsonString) as List;

      final products = decoded
          .map(
            (json) => ProductModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      print(
        'LOCAL STORAGE: ${products.length} products loaded successfully',
      );

      return products;
    } catch (e) {
      print('LOCAL STORAGE ERROR: $e');
      print('LOCAL STORAGE: Falling back to default products');

      return List.from(_defaultProducts);
    }
  }

  Future<bool> _saveProducts(List<ProductModel> products) async {
    print('==================================================');
    print('LOCAL DATA SOURCE: Saving products');
    print('==================================================');

    final jsonString =
        jsonEncode(products.map((p) => p.toJson()).toList());

    final result = await sharedPreferences.setString(
      cachedProductsKey,
      jsonString,
    );

    print(
      'LOCAL STORAGE: ${products.length} products saved',
    );
    print('LOCAL STORAGE: Save successful = $result');

    return result;
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    print('LOCAL DATA SOURCE: getAllProducts()');

    return _getStoredProducts();
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    print('LOCAL DATA SOURCE: getProductById($id)');

    final products = _getStoredProducts();

    for (final product in products) {
      if (product.id == id) {
        print(
          'LOCAL DATA SOURCE: Product $id found locally',
        );

        return product;
      }
    }

    print(
      'LOCAL DATA SOURCE: Product $id NOT found locally',
    );

    return null;
  }

  @override
  Future<void> cacheProducts(
    List<ProductModel> products,
  ) async {
    print(
      'LOCAL DATA SOURCE: cacheProducts(${products.length} products)',
    );

    await _saveProducts(products);
  }

  @override
  Future<void> cacheProduct(
    ProductModel product,
  ) async {
    print(
      'LOCAL DATA SOURCE: cacheProduct(${product.id})',
    );

    final products = _getStoredProducts();

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      print(
        'LOCAL DATA SOURCE: Adding product ${product.id} to cache',
      );

      products.add(product);
    } else {
      print(
        'LOCAL DATA SOURCE: Updating product ${product.id} in cache',
      );

      products[index] = product;
    }

    await _saveProducts(products);
  }

  @override
  Future<void> createProduct(
    ProductModel product,
  ) async {
    print(
      'LOCAL DATA SOURCE: createProduct(${product.id})',
    );

    final products = _getStoredProducts();

    products.add(product);

    await _saveProducts(products);

    print(
      'LOCAL DATA SOURCE: Product ${product.id} created locally',
    );
  }

  @override
  Future<bool> updateProduct(
    ProductModel product,
  ) async {
    print(
      'LOCAL DATA SOURCE: updateProduct(${product.id})',
    );

    final products = _getStoredProducts();

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      print(
        'LOCAL DATA SOURCE: Product ${product.id} not found',
      );

      return false;
    }

    products[index] = product;

    await _saveProducts(products);

    print(
      'LOCAL DATA SOURCE: Product ${product.id} updated locally',
    );

    return true;
  }

  @override
  Future<bool> deleteProduct(int id) async {
    print(
      'LOCAL DATA SOURCE: deleteProduct($id)',
    );

    final products = _getStoredProducts();

    final index = products.indexWhere(
      (product) => product.id == id,
    );

    if (index == -1) {
      print(
        'LOCAL DATA SOURCE: Product $id not found',
      );

      return false;
    }

    products.removeAt(index);

    await _saveProducts(products);

    print(
      'LOCAL DATA SOURCE: Product $id deleted locally',
    );

    return true;
  }
}