import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel?> getProductById(int id);

  Future<void> cacheProducts(List<ProductModel> products);

  Future<void> cacheProduct(ProductModel product);

  Future<void> createProduct(ProductModel product);

  Future<bool> updateProduct(ProductModel product);

  Future<bool> deleteProduct(int id);
}