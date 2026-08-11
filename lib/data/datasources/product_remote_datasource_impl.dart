import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load products',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception(
        'Invalid products response',
      );
    }

    return decoded
        .map(
          (json) => ProductModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<ProductModel> getProductById(
    int id,
  ) async {
    final response = await client.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load product',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Invalid product response',
      );
    }

    return ProductModel.fromJson(decoded);
  }

  @override
  Future<void> createProduct(
    ProductModel product,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        product.toJson(),
      ),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Failed to create product',
      );
    }
  }

  @override
  Future<void> updateProduct(
    ProductModel product,
  ) async {
    final response = await client.put(
      Uri.parse(
        '$baseUrl/products/${product.id}',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        product.toJson(),
      ),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Failed to update product',
      );
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse(
        '$baseUrl/products/$id',
      ),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Failed to delete product',
      );
    }
  }
}