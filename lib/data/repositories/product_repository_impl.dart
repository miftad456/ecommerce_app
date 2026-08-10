import 'package:dartz/dartz.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl
    implements ProductRepository {
  final ProductDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<Either<String, List<Product>>> getAllProducts() async {
    try {
      final products =
          datasource.getAllProducts();

      return Right(
        products
            .map(
              (product) => product.toEntity(),
            )
            .toList(),
      );
    } catch (e) {
      return Left(
        'Failed to load products.',
      );
    }
  }

  @override
  Future<Either<String, Product>> getProductById(
    int id,
  ) async {
    try {
      final product =
          datasource.getProductById(id);

      if (product == null) {
        return Left(
          'Product not found.',
        );
      }

      return Right(
        product.toEntity(),
      );
    } catch (e) {
      return Left(
        'Failed to load product.',
      );
    }
  }

  @override
  Future<Either<String, Unit>> createProduct(
    Product product,
  ) async {
    try {
      datasource.createProduct(
        ProductModel.fromEntity(product),
      );

      return const Right(unit);
    } catch (e) {
      return Left(
        'Failed to create product.',
      );
    }
  }

  @override
  Future<Either<String, Unit>> updateProduct(
    Product product,
  ) async {
    try {
      final updated =
          datasource.updateProduct(
        ProductModel.fromEntity(product),
      );

      if (!updated) {
        return Left(
          'Product not found.',
        );
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        'Failed to update product.',
      );
    }
  }

  @override
  Future<Either<String, Unit>> deleteProduct(
    int id,
  ) async {
    try {
      final deleted =
          datasource.deleteProduct(id);

      if (!deleted) {
        return Left(
          'Product not found.',
        );
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        'Failed to delete product.',
      );
    }
  }
}