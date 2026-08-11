import 'package:dartz/dartz.dart';

import '../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ============================================================
  // GET ALL PRODUCTS
  // ============================================================

  @override
  Future<Either<String, List<Product>>> getAllProducts() async {
    print('========================================');
    print('GET ALL PRODUCTS');
    print('========================================');

    try {
      final isConnected = await networkInfo.isConnected;

      print('Network connected: $isConnected');

      if (isConnected) {
        print('Using REMOTE data source');

        final products =
            await remoteDataSource.getAllProducts();

        print(
          'Remote products received: ${products.length}',
        );

        print('Caching remote products locally...');

        localDataSource.cacheProducts(products);

        print('Products cached successfully');

        return Right(products);
      }

      print('Using LOCAL data source');

      final products = localDataSource.getAllProducts();

      print(
        'Local products found: ${products.length}',
      );

      return Right(products);
    } catch (e) {
      print('GET ALL PRODUCTS ERROR: $e');

      return Left(e.toString());
    }
  }

  // ============================================================
  // GET PRODUCT BY ID
  // ============================================================

  @override
  Future<Either<String, Product>> getProductById(
    int id,
  ) async {
    print('========================================');
    print('GET PRODUCT BY ID');
    print('Product ID: $id');
    print('========================================');

    try {
      final isConnected = await networkInfo.isConnected;

      print('Network connected: $isConnected');

      if (isConnected) {
        print('Using REMOTE data source');

        final product =
            await remoteDataSource.getProductById(id);

        print(
          'Remote product received: ${product.id}',
        );

        print('Caching product locally...');

        localDataSource.cacheProduct(product);

        print('Product cached successfully');

        return Right(product);
      }

      print('Using LOCAL data source');

      final product =
          localDataSource.getProductById(id);

      if (product == null) {
        print(
          'Product with id $id was NOT found locally',
        );

        return Left(
          'Product with id $id not found locally',
        );
      }

      print(
        'Product with id $id found locally',
      );

      return Right(product);
    } catch (e) {
      print('GET PRODUCT BY ID ERROR: $e');

      return Left(e.toString());
    }
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  @override
Future<Either<String, Unit>> createProduct(
  Product product,
) async {
  print('========================================');
  print('CREATE PRODUCT');
  print('========================================');

  try {
    final productModel =
        ProductModel.fromEntity(product);

    print('Product converted successfully');

    // TEMPORARY TEST:
    // Directly save to local storage.
    localDataSource.createProduct(productModel);

    print('Product saved to LOCAL storage');

    final savedProduct =
        localDataSource.getProductById(product.id);

    print('Checking local storage...');

    if (savedProduct != null) {
      print(
        'LOCAL STORAGE TEST PASSED: '
        '${savedProduct.name}',
      );
    } else {
      print(
        'LOCAL STORAGE TEST FAILED',
      );
    }

    return Right(unit);
  } catch (e, stackTrace) {
    print('CREATE PRODUCT ERROR: $e');
    print(stackTrace);

    return Left(e.toString());
  }
}

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  @override
  Future<Either<String, Unit>> updateProduct(
    Product product,
  ) async {
    print('========================================');
    print('UPDATE PRODUCT');
    print('Product ID: ${product.id}');
    print('========================================');

    try {
      final productModel =
          ProductModel.fromEntity(product);

      final isConnected = await networkInfo.isConnected;

      print('Network connected: $isConnected');

      if (isConnected) {
        print('Using REMOTE data source');

        print(
          'Sending updated product to remote datasource...',
        );

        await remoteDataSource.updateProduct(
          productModel,
        );

        print(
          'Remote product update SUCCESSFUL',
        );

        print(
          'Updating local product cache...',
        );

        localDataSource.updateProduct(
          productModel,
        );

        print(
          'Local product update SUCCESSFUL',
        );

        print('UPDATE PRODUCT SUCCESS');

        return Right(unit);
      }

      print('Using LOCAL data source');

      final updated =
          localDataSource.updateProduct(
        productModel,
      );

      if (!updated) {
        print(
          'Product with id ${product.id} was NOT found locally',
        );

        return Left(
          'Product with id ${product.id} not found locally',
        );
      }

      print(
        'Product updated locally because device is offline',
      );

      print('UPDATE PRODUCT SUCCESS');

      return Right(unit);
    } catch (e) {
      print('========================================');
      print('UPDATE PRODUCT ERROR');
      print('Error: $e');
      print('========================================');

      return Left(e.toString());
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  @override
  Future<Either<String, Unit>> deleteProduct(
    int id,
  ) async {
    print('========================================');
    print('DELETE PRODUCT');
    print('Product ID: $id');
    print('========================================');

    try {
      final isConnected = await networkInfo.isConnected;

      print('Network connected: $isConnected');

      if (isConnected) {
        print('Using REMOTE data source');

        print(
          'Sending delete request to remote datasource...',
        );

        await remoteDataSource.deleteProduct(id);

        print(
          'Remote product deletion SUCCESSFUL',
        );

        print(
          'Deleting product from local cache...',
        );

        localDataSource.deleteProduct(id);

        print(
          'Local product deletion SUCCESSFUL',
        );

        print('DELETE PRODUCT SUCCESS');

        return Right(unit);
      }

      print('Using LOCAL data source');

      final deleted =
          localDataSource.deleteProduct(id);

      if (!deleted) {
        print(
          'Product with id $id was NOT found locally',
        );

        return Left(
          'Product with id $id not found locally',
        );
      }

      print(
        'Product deleted locally because device is offline',
      );

      print('DELETE PRODUCT SUCCESS');

      return Right(unit);
    } catch (e) {
      print('========================================');
      print('DELETE PRODUCT ERROR');
      print('Error: $e');
      print('========================================');

      return Left(e.toString());
    }
  }
}