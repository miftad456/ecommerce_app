import 'package:dio/dio.dart';

import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  ProductRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl = 'https://dummyjson.com',
  });

  @override
  Future<List<ProductModel>> getAllProducts() async {
    print('==================================================');
    print('REMOTE DATA SOURCE: Fetching products from API');
    print('REMOTE DATA SOURCE: GET $baseUrl/products');
    print('==================================================');

    final response = await dio.get('$baseUrl/products');

    print(
      'REMOTE DATA SOURCE: Response status = ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final data = response.data;

    List productsJson = [];

    if (data is Map<String, dynamic> &&
        data['products'] is List) {
      productsJson = data['products'] as List;
    } else if (data is List) {
      productsJson = data;
    } else {
      throw Exception('Invalid products response format');
    }

    final products = productsJson
        .map(
          (json) => ProductModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();

    print(
      'REMOTE DATA SOURCE: ${products.length} products received from API',
    );

    return products;
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    print('==================================================');
    print(
      'REMOTE DATA SOURCE: Fetching product $id from API',
    );
    print(
      'REMOTE DATA SOURCE: GET $baseUrl/products/$id',
    );
    print('==================================================');

    final response =
        await dio.get('$baseUrl/products/$id');

    print(
      'REMOTE DATA SOURCE: Response status = ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load product');
    }

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid product response format');
    }

    final product = ProductModel.fromJson(data);

    print(
      'REMOTE DATA SOURCE: Product ${product.id} received from API',
    );

    return product;
  }

  @override
  Future<void> createProduct(
    ProductModel product,
  ) async {
    print('==================================================');
    print(
      'REMOTE DATA SOURCE: Creating product ${product.id}',
    );
    print(
      'REMOTE DATA SOURCE: POST $baseUrl/products/add',
    );
    print('==================================================');

    final response = await dio.post(
      '$baseUrl/products/add',
      data: product.toJson(),
    );

    print(
      'REMOTE DATA SOURCE: Response status = ${response.statusCode}',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Failed to create product');
    }

    print(
      'REMOTE DATA SOURCE: Product ${product.id} created successfully',
    );
  }

  @override
  Future<void> updateProduct(
    ProductModel product,
  ) async {
    print('==================================================');
    print(
      'REMOTE DATA SOURCE: Updating product ${product.id}',
    );
    print(
      'REMOTE DATA SOURCE: PUT $baseUrl/products/${product.id}',
    );
    print('==================================================');

    final response = await dio.put(
      '$baseUrl/products/${product.id}',
      data: product.toJson(),
    );

    print(
      'REMOTE DATA SOURCE: Response status = ${response.statusCode}',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Failed to update product');
    }

    print(
      'REMOTE DATA SOURCE: Product ${product.id} updated successfully',
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    print('==================================================');
    print(
      'REMOTE DATA SOURCE: Deleting product $id',
    );
    print(
      'REMOTE DATA SOURCE: DELETE $baseUrl/products/$id',
    );
    print('==================================================');

    final response =
        await dio.delete('$baseUrl/products/$id');

    print(
      'REMOTE DATA SOURCE: Response status = ${response.statusCode}',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception('Failed to delete product');
    }

    print(
      'REMOTE DATA SOURCE: Product $id deleted successfully',
    );
  }
}