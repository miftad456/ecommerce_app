// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../../data/models/product_model.dart';

// class MockHttpClient extends http.BaseClient {
//   final List<ProductModel> _products = [
//     const ProductModel(
//       id: 1,
//       name: 'Gaming Laptop',
//       description: 'Powerful laptop for work and gaming.',
//       imageUrl: '',
//       price: 1500,
//     ),
//     const ProductModel(
//       id: 2,
//       name: 'Smartphone',
//       description: 'Modern smartphone with 5G support.',
//       imageUrl: '',
//       price: 800,
//     ),
//     const ProductModel(
//       id: 3,
//       name: 'Wireless Headphones',
//       description: 'Comfortable headphones with clear sound.',
//       imageUrl: '',
//       price: 120,
//     ),
//   ];

//   @override
//   Future<http.StreamedResponse> send(
//     http.BaseRequest request,
//   ) async {
//     final path = request.url.path;

//     // ==========================================================
//     // GET /products
//     // ==========================================================

//     if (request.method == 'GET' &&
//         path == '/api/products') {
//       return _response(
//         statusCode: 200,
//         body: jsonEncode(
//           _products
//               .map((product) => product.toJson())
//               .toList(),
//         ),
//       );
//     }

//     // ==========================================================
//     // GET /products/:id
//     // ==========================================================

//     if (request.method == 'GET' &&
//         path.startsWith('/api/products/')) {
//       final id = int.tryParse(
//         path.split('/').last,
//       );

//       if (id == null) {
//         return _response(
//           statusCode: 400,
//           body: jsonEncode({
//             'message': 'Invalid product id',
//           }),
//         );
//       }

//       final index = _products.indexWhere(
//         (product) => product.id == id,
//       );

//       if (index == -1) {
//         return _response(
//           statusCode: 404,
//           body: jsonEncode({
//             'message': 'Product not found',
//           }),
//         );
//       }

//       return _response(
//         statusCode: 200,
//         body: jsonEncode(
//           _products[index].toJson(),
//         ),
//       );
//     }

//     // ==========================================================
//     // POST /products
//     // ==========================================================

//     if (request.method == 'POST' &&
//         path == '/api/products') {
//       final body = await request.finalize().bytesToString();

//       final json = jsonDecode(body) as Map<String, dynamic>;

//       final product = ProductModel.fromJson(json);

//       final exists = _products.any(
//         (item) => item.id == product.id,
//       );

//       if (exists) {
//         return _response(
//           statusCode: 409,
//           body: jsonEncode({
//             'message': 'Product already exists',
//           }),
//         );
//       }

//       _products.add(product);

//       return _response(
//         statusCode: 201,
//         body: jsonEncode(
//           product.toJson(),
//         ),
//       );
//     }

//     // ==========================================================
//     // PUT /products/:id
//     // ==========================================================

//     if (request.method == 'PUT' &&
//         path.startsWith('/api/products/')) {
//       final id = int.tryParse(
//         path.split('/').last,
//       );

//       if (id == null) {
//         return _response(
//           statusCode: 400,
//           body: jsonEncode({
//             'message': 'Invalid product id',
//           }),
//         );
//       }

//       final body = await request.finalize().bytesToString();

//       final json = jsonDecode(body) as Map<String, dynamic>;

//       final product = ProductModel.fromJson(json);

//       final index = _products.indexWhere(
//         (item) => item.id == id,
//       );

//       if (index == -1) {
//         return _response(
//           statusCode: 404,
//           body: jsonEncode({
//             'message': 'Product not found',
//           }),
//         );
//       }

//       _products[index] = product;

//       return _response(
//         statusCode: 200,
//         body: jsonEncode(
//           product.toJson(),
//         ),
//       );
//     }

//     // ==========================================================
//     // DELETE /products/:id
//     // ==========================================================

//     if (request.method == 'DELETE' &&
//         path.startsWith('/api/products/')) {
//       final id = int.tryParse(
//         path.split('/').last,
//       );

//       if (id == null) {
//         return _response(
//           statusCode: 400,
//           body: jsonEncode({
//             'message': 'Invalid product id',
//           }),
//         );
//       }

//       final index = _products.indexWhere(
//         (product) => product.id == id,
//       );

//       if (index == -1) {
//         return _response(
//           statusCode: 404,
//           body: jsonEncode({
//             'message': 'Product not found',
//           }),
//         );
//       }

//       _products.removeAt(index);

//       return _response(
//         statusCode: 204,
//         body: '',
//       );
//     }

//     // ==========================================================
//     // Unknown endpoint
//     // ==========================================================

//     return _response(
//       statusCode: 404,
//       body: jsonEncode({
//         'message': 'Endpoint not found',
//       }),
//     );
//   }

//   http.StreamedResponse _response({
//     required int statusCode,
//     required String body,
//   }) {
//     return http.StreamedResponse(
//       Stream.value(
//         utf8.encode(body),
//       ),
//       statusCode,
//       headers: {
//         'content-type': 'application/json',
//       },
//     );
//   }
// }