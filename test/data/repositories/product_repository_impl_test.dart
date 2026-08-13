import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';


class FakeNetworkInfo implements NetworkInfo {
  bool connected;

  FakeNetworkInfo({
    this.connected = false,
  });

  @override
  Future<bool> get isConnected async {
    return connected;
  }
}

class FakeRemoteDataSource
    implements ProductRemoteDataSource {
  final List<ProductModel> products;

  bool getAllProductsCalled = false;
  bool getProductByIdCalled = false;
  bool createProductCalled = false;
  bool updateProductCalled = false;
  bool deleteProductCalled = false;

  FakeRemoteDataSource({
    List<ProductModel>? products,
  }) : products = products ?? [];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    getAllProductsCalled = true;

    return List.unmodifiable(products);
  }

  @override
  Future<ProductModel> getProductById(
    int id,
  ) async {
    getProductByIdCalled = true;

    return products.firstWhere(
      (product) => product.id == id,
    );
  }

  @override
  Future<void> createProduct(
    ProductModel product,
  ) async {
    createProductCalled = true;

    products.add(product);
  }

  @override
  Future<void> updateProduct(
    ProductModel product,
  ) async {
    updateProductCalled = true;

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(
    int id,
  ) async {
    deleteProductCalled = true;

    products.removeWhere(
      (product) => product.id == id,
    );
  }
}

class FakeLocalDataSource
    implements ProductLocalDataSource {
  final List<ProductModel> products;

  bool getAllProductsCalled = false;
  bool getProductByIdCalled = false;
  bool cacheProductsCalled = false;
  bool cacheProductCalled = false;
  bool createProductCalled = false;
  bool updateProductCalled = false;
  bool deleteProductCalled = false;

  FakeLocalDataSource({
    List<ProductModel>? products,
  }) : products = products ?? [];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    getAllProductsCalled = true;

    return List.unmodifiable(products);
  }

  @override
  Future<ProductModel?> getProductById(
    int id,
  ) async {
    getProductByIdCalled = true;

    for (final product in products) {
      if (product.id == id) {
        return product;
      }
    }

    return null;
  }

  @override
  Future<void> cacheProducts(
    List<ProductModel> products,
  ) async {
    cacheProductsCalled = true;

    this.products
      ..clear()
      ..addAll(products);
  }

  @override
  Future<void> cacheProduct(
    ProductModel product,
  ) async {
    cacheProductCalled = true;

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      products.add(product);
    } else {
      products[index] = product;
    }
  }

  @override
  Future<void> createProduct(
    ProductModel product,
  ) async {
    createProductCalled = true;

    products.add(product);
  }

  @override
  Future<bool> updateProduct(
    ProductModel product,
  ) async {
    updateProductCalled = true;

    final index = products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      return false;
    }

    products[index] = product;

    return true;
  }

  @override
  Future<bool> deleteProduct(
    int id,
  ) async {
    deleteProductCalled = true;

    final index = products.indexWhere(
      (product) => product.id == id,
    );

    if (index == -1) {
      return false;
    }

    products.removeAt(index);

    return true;
  }
}

void main() {
  late ProductRepositoryImpl repository;
  late FakeNetworkInfo networkInfo;
  late FakeRemoteDataSource remoteDataSource;
  late FakeLocalDataSource localDataSource;

  const remoteProduct = ProductModel(
    id: 1,
    name: 'Remote Laptop',
    description: 'Laptop from remote API',
    imageUrl: 'remote.jpg',
    price: 2000,
  );

  const localProduct = ProductModel(
    id: 2,
    name: 'Local Phone',
    description: 'Phone from local storage',
    imageUrl: 'local.jpg',
    price: 800,
  );

  setUp(() {
    networkInfo = FakeNetworkInfo(
      connected: false,
    );

    remoteDataSource = FakeRemoteDataSource(
      products: [
        remoteProduct,
      ],
    );

    localDataSource = FakeLocalDataSource(
      products: [
        localProduct,
      ],
    );

    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group(
    'getAllProducts',
    () {
      test(
        'should use remote datasource when online',
        () async {
          networkInfo.connected = true;

          final result =
              await repository.getAllProducts();

          result.fold(
            (failure) {
              fail(
                'Expected success but got: $failure',
              );
            },
            (products) {
              expect(products.length, 1);
              expect(
                products.first.id,
                remoteProduct.id,
              );
            },
          );

          expect(
            remoteDataSource.getAllProductsCalled,
            true,
          );

          expect(
            localDataSource.getAllProductsCalled,
            false,
          );
        },
      );

      test(
        'should cache remote products when online',
        () async {
          networkInfo.connected = true;

          await repository.getAllProducts();

          expect(
            localDataSource.cacheProductsCalled,
            true,
          );

          expect(
            localDataSource.products.length,
            1,
          );

          expect(
            localDataSource.products.first.id,
            remoteProduct.id,
          );
        },
      );

      test(
        'should use local datasource when offline',
        () async {
          networkInfo.connected = false;

          final result =
              await repository.getAllProducts();

          result.fold(
            (failure) {
              fail(
                'Expected success but got: $failure',
              );
            },
            (products) {
              expect(products.length, 1);
              expect(
                products.first.id,
                localProduct.id,
              );
            },
          );

          expect(
            localDataSource.getAllProductsCalled,
            true,
          );

          expect(
            remoteDataSource.getAllProductsCalled,
            false,
          );
        },
      );
    },
  );

  group(
    'getProductById',
    () {
      test(
        'should use remote datasource when online',
        () async {
          networkInfo.connected = true;

          final result =
              await repository.getProductById(1);

          result.fold(
            (failure) {
              fail(
                'Expected success but got: $failure',
              );
            },
            (product) {
              expect(
                product.id,
                remoteProduct.id,
              );
            },
          );

          expect(
            remoteDataSource.getProductByIdCalled,
            true,
          );

          expect(
            localDataSource.getProductByIdCalled,
            false,
          );
        },
      );

      test(
        'should cache remote product when online',
        () async {
          networkInfo.connected = true;

          await repository.getProductById(1);

          expect(
            localDataSource.cacheProductCalled,
            true,
          );

          expect(
            (await localDataSource.getProductById(1))?.id,
            remoteProduct.id,
          );
        },
      );

      test(
        'should use local datasource when offline',
        () async {
          networkInfo.connected = false;

          final result =
              await repository.getProductById(2);

          result.fold(
            (failure) {
              fail(
                'Expected success but got: $failure',
              );
            },
            (product) {
              expect(
                product.id,
                localProduct.id,
              );
            },
          );

          expect(
            localDataSource.getProductByIdCalled,
            true,
          );

          expect(
            remoteDataSource.getProductByIdCalled,
            false,
          );
        },
      );
    },
  );

  group(
    'createProduct',
    () {
      const product = Product(
        id: 3,
        name: 'Tablet',
        description: 'New tablet',
        imageUrl: 'tablet.jpg',
        price: 500,
      );

      test(
        'should create remotely and locally when online',
        () async {
          networkInfo.connected = true;

          final result =
              await repository.createProduct(product);

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.createProductCalled,
            true,
          );

          expect(
            localDataSource.cacheProductCalled,
            true,
          );
        },
      );

      test(
        'should create locally when offline',
        () async {
          networkInfo.connected = false;

          final result =
              await repository.createProduct(product);

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.createProductCalled,
            false,
          );

          expect(
            localDataSource.createProductCalled,
            true,
          );
        },
      );
    },
  );

  group(
    'updateProduct',
    () {
      const updatedProduct = Product(
        id: 2,
        name: 'Updated Phone',
        description: 'Updated phone',
        imageUrl: 'updated.jpg',
        price: 900,
      );

      test(
        'should update remotely and locally when online',
        () async {
          networkInfo.connected = true;

          final result =
              await repository.updateProduct(
            updatedProduct,
          );

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.updateProductCalled,
            true,
          );

          expect(
            localDataSource.updateProductCalled,
            true,
          );
        },
      );

      test(
        'should update locally when offline',
        () async {
          networkInfo.connected = false;

          final result =
              await repository.updateProduct(
            updatedProduct,
          );

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.updateProductCalled,
            false,
          );

          expect(
            localDataSource.updateProductCalled,
            true,
          );
        },
      );
    },
  );

  group(
    'deleteProduct',
    () {
      test(
        'should delete remotely and locally when online',
        () async {
          networkInfo.connected = true;

          final result =
              await repository.deleteProduct(2);

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.deleteProductCalled,
            true,
          );

          expect(
            localDataSource.deleteProductCalled,
            true,
          );
        },
      );

      test(
        'should delete locally when offline',
        () async {
          networkInfo.connected = false;

          final result =
              await repository.deleteProduct(2);

          expect(
            result.isRight(),
            true,
          );

          expect(
            remoteDataSource.deleteProductCalled,
            false,
          );

          expect(
            localDataSource.deleteProductCalled,
            true,
          );
        },
      );
    },
  );
}