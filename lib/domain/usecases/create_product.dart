import 'package:dartz/dartz.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Either<String, Unit>> call(
    Product product,
  ) {
    return repository.createProduct(product);
  }
}