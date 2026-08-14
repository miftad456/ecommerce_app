import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

class ProductInitial extends ProductState {
  const ProductInitial();
}

// ============================================================
// LOADING
// ============================================================

class ProductLoading extends ProductState {
  const ProductLoading();
}

// ============================================================
// LOADED
// ============================================================

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

// ============================================================
// SINGLE PRODUCT LOADED
// ============================================================

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

// ============================================================
// OPERATION SUCCESS
// ============================================================

class ProductOperationSuccess extends ProductState {
  final String message;
  final List<Product>? products;

  const ProductOperationSuccess({
    required this.message,
    this.products,
  });

  @override
  List<Object?> get props => [
        message,
        products,
      ];
}

// ============================================================
// ERROR
// ============================================================

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}