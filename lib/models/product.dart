// ============================================================
// PRODUCT MODEL
// ============================================================
//
// This class represents a product in our ecommerce application.
//
// A Product has:
// - id
// - title
// - description
// - price
//
// ============================================================

class Product {
  final int id;

  String title;
  String description;
  double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });
}