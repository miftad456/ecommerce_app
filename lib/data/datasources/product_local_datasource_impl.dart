import '../models/product_model.dart';
import 'product_local_datasource.dart';

class ProductLocalDataSourceImpl
    implements ProductLocalDataSource {
  final List<ProductModel> _products = [
    const ProductModel(
      id: 1,
      name: 'Gaming Laptop',
      description: 'Powerful laptop for work and gaming.',
      imageUrl: '',
      price: 1500,
    ),
    const ProductModel(
      id: 2,
      name: 'Smartphone',
      description: 'Modern smartphone with 5G support.',
      imageUrl: '',
      price: 800,
    ),
    const ProductModel(
      id: 3,
      name: 'Wireless Headphones',
      description: 'Comfortable headphones with clear sound.',
      imageUrl: '',
      price: 120,
    ),
  ];

  @override
  List<ProductModel> getAllProducts() {
    return List.unmodifiable(_products);
  }

  @override
  ProductModel? getProductById(int id) {
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }

    return null;
  }

  @override
  void cacheProducts(List<ProductModel> products) {
    _products
      ..clear()
      ..addAll(products);
  }

  @override
  void cacheProduct(ProductModel product) {
    final index = _products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      _products.add(product);
    } else {
      _products[index] = product;
    }
  }

  @override
  void createProduct(ProductModel product) {
    _products.add(product);
  }

  @override
  bool updateProduct(ProductModel product) {
    final index = _products.indexWhere(
      (item) => item.id == product.id,
    );

    if (index == -1) {
      return false;
    }

    _products[index] = product;

    return true;
  }

  @override
  bool deleteProduct(int id) {
    final index = _products.indexWhere(
      (product) => product.id == id,
    );

    if (index == -1) {
      return false;
    }

    _products.removeAt(index);

    return true;
  }
}