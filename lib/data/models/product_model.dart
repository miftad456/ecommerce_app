import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final image = json['thumbnail'] as String? ??
        json['imageUrl'] as String? ??
        (json['images'] is List && (json['images'] as List).isNotEmpty
            ? (json['images'] as List).first.toString()
            : '');

    return ProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['title'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: image,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'name': name,
      'description': description,
      'thumbnail': imageUrl,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory ProductModel.fromEntity(
    Product product,
  ) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }
}