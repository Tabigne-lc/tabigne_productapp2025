import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class CategoryService {
  // Static method to fetch categories from the API
  static Future<List<Map<String, dynamic>>> getCategories() async {
    // Construct the URL using the base URL from AppConfig
    final url = Uri.parse('${AppConfig.baseUrl}/api/categories');

    try {
      // Send HTTP GET request to the categories endpoint
      final response = await http.get(url);

      // Check if the request was successful (HTTP status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response into a List of dynamic objects
        List<dynamic> data = jsonDecode(response.body);

        // Convert each item to a Map with only 'id' and 'name' keys
        return data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList(); // Return as a list of maps
      } else {
        // If the server did not return a 200 OK response, throw an error
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Catch any network or parsing errors
      throw Exception('Network error occurred');
    }
  }
}
