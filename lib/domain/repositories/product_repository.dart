import 'package:dartz/dartz.dart';

import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<String, List<Product>>> getAllProducts();

  Future<Either<String, Product>> getProductById(
    int id,
  );

  Future<Either<String, Unit>> createProduct(
    Product product,
  );

  Future<Either<String, Unit>> updateProduct(
    Product product,
  );

  Future<Either<String, Unit>> deleteProduct(
    int id,
  );
}