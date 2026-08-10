import 'package:dartz/dartz.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewAllProducts {
  final ProductRepository repository;

  ViewAllProducts(this.repository);

  Future<Either<String, List<Product>>> call() {
    return repository.getAllProducts();
  }
}