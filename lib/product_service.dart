import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'product.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/api/products?all=1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['data'] ?? data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/categories/$categoryId/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['data'] ?? data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products for category');
    }
  }

  static Future<Map<String, dynamic>> fetchProductsByCategoryPaginated(
      int categoryId, int page) async {
    final response = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/api/categories/$categoryId/products?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['data'] ?? [];
      final List<Product> products =
          productsJson.map((json) => Product.fromJson(json)).toList();
      final bool hasMore = data['next_page_url'] != null ||
          (data['current_page'] ?? 1) < (data['last_page'] ?? 1);
      return {
        'products': products,
        'hasMore': hasMore,
      };
    } else {
      throw Exception('Failed to load products for category');
    }
  }
}
