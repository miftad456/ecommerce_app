import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({
    required this.productRepository,
  }) : super(const ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<GetProductByIdEvent>(_onGetProductById);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  // ============================================================
  // GET ALL PRODUCTS
  // ============================================================

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await productRepository.getAllProducts();

      result.fold(
        (failure) => emit(ProductError(failure)),
        (products) => emit(ProductsLoaded(products)),
      );
    } catch (e) {
      emit(
        ProductError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // GET PRODUCT BY ID
  // ============================================================

  Future<void> _onGetProductById(
    GetProductByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await productRepository.getProductById(
        event.id,
      );

      result.fold(
        (failure) => emit(ProductError(failure)),
        (product) => emit(ProductLoaded(product)),
      );
    } catch (e) {
      emit(
        ProductError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await productRepository.createProduct(
        event.product,
      );

      await result.fold(
        (failure) async => emit(ProductError(failure)),
        (_) async {
          final productsResult = await productRepository.getAllProducts();
          final products = productsResult.fold(
            (_) => null,
            (list) => list,
          );

          emit(
            ProductOperationSuccess(
              message: 'Product added successfully.',
              products: products,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        ProductError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await productRepository.updateProduct(
        event.product,
      );

      await result.fold(
        (failure) async => emit(ProductError(failure)),
        (_) async {
          final productsResult = await productRepository.getAllProducts();
          final products = productsResult.fold(
            (_) => null,
            (list) => list,
          );

          emit(
            ProductOperationSuccess(
              message: 'Product updated successfully.',
              products: products,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        ProductError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await productRepository.deleteProduct(
        event.id,
      );

      await result.fold(
        (failure) async => emit(ProductError(failure)),
        (_) async {
          final productsResult = await productRepository.getAllProducts();
          final products = productsResult.fold(
            (_) => null,
            (list) => list,
          );

          emit(
            ProductOperationSuccess(
              message: 'Product deleted successfully.',
              products: products,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        ProductError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }
}