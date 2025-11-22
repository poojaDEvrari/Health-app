import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:relax_doc/config.dart';
import 'package:relax_doc/models/product.dart';
import 'dart:io';
import 'package:relax_doc/services/token_store.dart';

class ProductService {
  static const String _basePath = "$serverBase/product-service/products";

  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_basePath/getAllProducts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final products = (data['data'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
          return products;
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<List<Product>> getNewEquipment() async {
    final products = await getAllProducts();
    return products.where((p) => p.productType == 'NEW').toList();
  }

  static Future<List<Product>> getUsedEquipment() async {
    final products = await getAllProducts();
    return products.where((p) => p.productType == 'USED').toList();
  }

  static Future<List<Product>> getBestSellingProducts() async {
    final products = await getAllProducts();
    // Get first 4 products as best selling (you might want to sort by some criteria)
    return products.take(4).toList();
  }

  static Future<List<String>> getCategories() async {
    return [
      'Medicine',
      'Pain Relief',
      'Digestive Care',
      'Cardio Care',
      'Women Care',
      'Skin Care',
      'Oxygen Max',
      'Diabetes Care',
    ];
  }

  static Future<List<Map<String, dynamic>>> getFeaturedPartners() async {
    final products = await getAllProducts();
    final vendors = <String, Map<String, dynamic>>{};
    
    for (var product in products) {
      if (product.vendorId != null && product.soldByVendorName != null) {
        vendors[product.vendorId.toString()] = {
          'id': product.vendorId,
          'name': product.soldByVendorName,
          'image': product.imagesUrl.isNotEmpty ? product.imagesUrl[0] : null,
        };
      }
    }
    
    return vendors.values.toList();
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> payload) async {
    final uri = Uri.parse("$serverBase/product-service/products/createProduct");
    final token = await TokenStore.getToken();
    final headers = {"Content-Type": "application/json", if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"};
    final res = await http.post(uri, headers: headers, body: jsonEncode(payload));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Create product failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    return (decoded['data'] ?? {}) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> payload) async {
    final uri = Uri.parse("$serverBase/product-service/products/updateProduct/$id");
    final token = await TokenStore.getToken();
    final headers = {"Content-Type": "application/json", if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"};
    final res = await http.put(uri, headers: headers, body: jsonEncode(payload));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Update product failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    return (decoded['data'] ?? {}) as Map<String, dynamic>;
  }

  /// Upload a file to S3 via backend and return the public URL string.
  /// Endpoint: POST /product-service/products/uploadToS3
  static Future<String> uploadToS3(File file) async {
    final uri = Uri.parse("$serverBase/product-service/products/uploadToS3");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Upload failed: ${res.statusCode} ${res.body}');
    }
    final decoded = jsonDecode(res.body);
    // Try common response shapes
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is String) return data; // direct URL
      if (data is Map) {
        final url = data['url'] ?? data['location'] ?? data['Location'];
        if (url is String && url.isNotEmpty) return url;
      }
      final url = decoded['url'] ?? decoded['Location'];
      if (url is String && url.isNotEmpty) return url;
    }
    throw Exception('Upload succeeded but URL not found in response');
  }
}
