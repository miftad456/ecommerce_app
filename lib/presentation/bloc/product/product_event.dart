import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// GET ALL PRODUCTS
// ============================================================

class GetProductsEvent extends ProductEvent {
  const GetProductsEvent();
}

// ============================================================
// GET PRODUCT BY ID
// ============================================================

class GetProductByIdEvent extends ProductEvent {
  final int id;

  const GetProductByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// ============================================================
// CREATE / ADD PRODUCT
// ============================================================

class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Alias for compatibility
typedef AddProductEvent = CreateProductEvent;

// ============================================================
// UPDATE PRODUCT
// ============================================================

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// ============================================================
// DELETE PRODUCT
// ============================================================

class DeleteProductEvent extends ProductEvent {
  final int id;

  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}