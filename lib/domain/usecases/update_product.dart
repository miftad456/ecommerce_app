import 'package:dartz/dartz.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Either<String, Unit>> call(
    Product product,
  ) {
    return repository.updateProduct(product);
  }
}