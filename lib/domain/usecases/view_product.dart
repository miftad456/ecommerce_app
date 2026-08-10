import 'package:dartz/dartz.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProduct {
  final ProductRepository repository;

  ViewProduct(this.repository);

  Future<Either<String, Product>> call(
    int id,
  ) {
    return repository.getProductById(id);
  }
}