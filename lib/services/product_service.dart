import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:relax_doc/config.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/data/demo_products.dart';

class ProductService {
  static const String _path = "/product-service/products/getAllProducts";

  static Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DemoProducts.all();
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> payload) async {
    final uri = Uri.parse("$serverBase/product-service/products/createProduct");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Create product failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    return (decoded['data'] ?? {}) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> payload) async {
    final uri = Uri.parse("$serverBase/product-service/products/updateProduct/$id");
    final res = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update product failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    return (decoded['data'] ?? {}) as Map<String, dynamic>;
  }
}
