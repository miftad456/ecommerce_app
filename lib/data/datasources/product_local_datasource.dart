import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  List<ProductModel> getAllProducts();

  ProductModel? getProductById(int id);

  void cacheProducts(List<ProductModel> products);

  void cacheProduct(ProductModel product);

  void createProduct(ProductModel product);

  bool updateProduct(ProductModel product);

  bool deleteProduct(int id);
}