import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'product.dart';

class ProductService {
  // Fetches all products from the API (with ?all=1 to ensure full list)
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/api/products?all=1'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Extract 'data' array if it exists; otherwise use entire response
      final List productsJson = data['data'] ?? data;
      
      // Convert each JSON object to a Product instance
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      // Throw error if request fails
      throw Exception('Failed to load products');
    }
  }

  // Fetches products belonging to a specific category
  static Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/categories/$categoryId/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Get list of products from 'data', fallback to entire body if needed
      final List productsJson = data['data'] ?? data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products for category');
    }
  }

  // Fetches products by category with pagination
  // Returns both products list and a boolean indicating if there's more data
  static Future<Map<String, dynamic>> fetchProductsByCategoryPaginated(
      int categoryId, int page) async {
    final response = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/api/categories/$categoryId/products?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract product list from response
      final List productsJson = data['data'] ?? [];
      final List<Product> products =
          productsJson.map((json) => Product.fromJson(json)).toList();

      // Determine if there are more pages to load
      final bool hasMore = data['next_page_url'] != null ||
          (data['current_page'] ?? 1) < (data['last_page'] ?? 1);

      // Return both the list and hasMore flag
      return {
        'products': products,
        'hasMore': hasMore,
      };
    } else {
      throw Exception('Failed to load products for category');
    }
  }
}
