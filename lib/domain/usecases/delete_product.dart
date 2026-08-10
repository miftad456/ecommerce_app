import 'package:dartz/dartz.dart';

import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<String, Unit>> call(
    int id,
  ) {
    return repository.deleteProduct(id);
  }
}