class Product {
  // Product fields
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final int userId;
  final String? imagePath; // Optional image path

  // Constructor with required and optional parameters
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.userId,
    this.imagePath,
  });

  // Factory constructor to create a Product instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], // Parse ID
      name: json['name'], // Parse name
      description: json['description'], // Parse description
      price: double.parse(json['price'].toString()), 
      // Ensure price is a double (may come as string or number)

      categoryId: json['category_id'], // Parse category ID
      userId: json['user_id'], // Parse user ID
      imagePath: json['image_path'], // Parse optional image path
    );
  }
}
