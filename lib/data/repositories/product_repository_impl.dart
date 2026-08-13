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
    try {
      print('');
      print('##################################################');
      print('REPOSITORY: getAllProducts()');
      print('REPOSITORY: Checking internet connection...');
      print('##################################################');

      final isConnected = await networkInfo.isConnected;

      print(
        'REPOSITORY: Internet connected = $isConnected',
      );

      if (isConnected) {
        print('');
        print('>>> REPOSITORY DECISION: USE REMOTE DATA SOURCE <<<');
        print('>>> Fetching products from API...');
        print('');

        final products =
            await remoteDataSource.getAllProducts();

        print(
          'REPOSITORY: Remote products received: ${products.length}',
        );

        print(
          'REPOSITORY: Caching remote products locally...',
        );

        await localDataSource.cacheProducts(products);

        print(
          'REPOSITORY: Remote products cached successfully',
        );

        return Right(products);
      }

      print('');
      print('>>> REPOSITORY DECISION: USE LOCAL DATA SOURCE <<<');
      print('>>> Internet is not available');
      print('>>> Reading products from local storage...');
      print('');

      final products =
          await localDataSource.getAllProducts();

      print(
        'REPOSITORY: Local products received: ${products.length}',
      );

      return Right(products);
    } catch (e) {
      print('REPOSITORY ERROR: $e');

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
    try {
      print('');
      print('##################################################');
      print('REPOSITORY: getProductById($id)');
      print('REPOSITORY: Checking internet connection...');
      print('##################################################');

      final isConnected = await networkInfo.isConnected;

      print(
        'REPOSITORY: Internet connected = $isConnected',
      );

      if (isConnected) {
        print('');
        print(
          '>>> REPOSITORY DECISION: USE REMOTE DATA SOURCE <<<',
        );
        print(
          '>>> Fetching product $id from API...',
        );
        print('');

        final product =
            await remoteDataSource.getProductById(id);

        print(
          'REPOSITORY: Remote product $id received',
        );

        await localDataSource.cacheProduct(product);

        print(
          'REPOSITORY: Product $id cached locally',
        );

        return Right(product);
      }

      print('');
      print(
        '>>> REPOSITORY DECISION: USE LOCAL DATA SOURCE <<<',
      );
      print(
        '>>> Reading product $id from local storage...',
      );
      print('');

      final product =
          await localDataSource.getProductById(id);

      if (product == null) {
        print(
          'REPOSITORY: Product $id not found locally',
        );

        return Left(
          'Product with id $id not found locally',
        );
      }

      print(
        'REPOSITORY: Product $id found locally',
      );

      return Right(product);
    } catch (e) {
      print('REPOSITORY ERROR: $e');

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
    try {
      print('');
      print('##################################################');
      print('REPOSITORY: createProduct()');
      print('##################################################');

      final productModel =
          ProductModel.fromEntity(product);

      final isConnected =
          await networkInfo.isConnected;

      print(
        'REPOSITORY: Internet connected = $isConnected',
      );

      if (isConnected) {
        print(
          '>>> REPOSITORY DECISION: USE REMOTE DATA SOURCE <<<',
        );

        await remoteDataSource.createProduct(
          productModel,
        );

        print(
          'REPOSITORY: Product created remotely',
        );

        await localDataSource.cacheProduct(
          productModel,
        );

        print(
          'REPOSITORY: Product cached locally',
        );

        return const Right(unit);
      }

      print(
        '>>> REPOSITORY DECISION: USE LOCAL DATA SOURCE <<<',
      );

      await localDataSource.createProduct(
        productModel,
      );

      print(
        'REPOSITORY: Product created locally',
      );

      return const Right(unit);
    } catch (e) {
      print('REPOSITORY ERROR: $e');

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
    try {
      print('');
      print('##################################################');
      print(
        'REPOSITORY: updateProduct(${product.id})',
      );
      print('##################################################');

      final productModel =
          ProductModel.fromEntity(product);

      final isConnected =
          await networkInfo.isConnected;

      print(
        'REPOSITORY: Internet connected = $isConnected',
      );

      if (isConnected) {
        print(
          '>>> REPOSITORY DECISION: USE REMOTE DATA SOURCE <<<',
        );

        await remoteDataSource.updateProduct(
          productModel,
        );

        print(
          'REPOSITORY: Product ${product.id} updated remotely',
        );

        await localDataSource.updateProduct(
          productModel,
        );

        print(
          'REPOSITORY: Product ${product.id} updated locally',
        );

        return const Right(unit);
      }

      print(
        '>>> REPOSITORY DECISION: USE LOCAL DATA SOURCE <<<',
      );

      final updated =
          await localDataSource.updateProduct(
        productModel,
      );

      if (!updated) {
        print(
          'REPOSITORY: Product ${product.id} not found locally',
        );

        return Left(
          'Product with id ${product.id} not found locally',
        );
      }

      print(
        'REPOSITORY: Product ${product.id} updated locally',
      );

      return const Right(unit);
    } catch (e) {
      print('REPOSITORY ERROR: $e');

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
    try {
      print('');
      print('##################################################');
      print('REPOSITORY: deleteProduct($id)');
      print('##################################################');

      final isConnected =
          await networkInfo.isConnected;

      print(
        'REPOSITORY: Internet connected = $isConnected',
      );

      if (isConnected) {
        print(
          '>>> REPOSITORY DECISION: USE REMOTE DATA SOURCE <<<',
        );

        await remoteDataSource.deleteProduct(id);

        print(
          'REPOSITORY: Product $id deleted remotely',
        );

        await localDataSource.deleteProduct(id);

        print(
          'REPOSITORY: Product $id deleted locally',
        );

        return const Right(unit);
      }

      print(
        '>>> REPOSITORY DECISION: USE LOCAL DATA SOURCE <<<',
      );

      final deleted =
          await localDataSource.deleteProduct(id);

      if (!deleted) {
        print(
          'REPOSITORY: Product $id not found locally',
        );

        return Left(
          'Product with id $id not found locally',
        );
      }

      print(
        'REPOSITORY: Product $id deleted locally',
      );

      return const Right(unit);
    } catch (e) {
      print('REPOSITORY ERROR: $e');

      return Left(e.toString());
    }
  }
}