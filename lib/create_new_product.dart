import 'package:flutter/material.dart';
import 'models/language_model.dart';
import 'models/background_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'category_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'config.dart';

class CreateNewProduct extends StatefulWidget {
  const CreateNewProduct({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

// Service class for sending new product data to the backend
class CreateNewProductService {
  // Method to add a product via HTTP POST request
  static Future<bool> addProduct({
    required String name,
    required String description,
    required String price,
    required int categoryId,
    required int userId,
    File? image,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/products'); // API endpoint
    var request = http.MultipartRequest('POST', url); // Multipart request for sending file and data

    // Add form fields to the request
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['category_id'] = categoryId.toString();
    request.fields['user_id'] = userId.toString();

    // If an image is selected, attach it to the request
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send(); // Send request to server
    if (response.statusCode == 201) {
      return true; // Product successfully created
    } else {
      throw Exception('Failed to add product'); // Handle failure
    }
  }
}

class _AddProductScreenState extends State<CreateNewProduct> {
  String? selectedCategory; // Stores selected category ID (as string)
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<Map<String, dynamic>> categories = []; // List of category options
  bool isLoadingCategories = true; // Show loader until categories are fetched

  File? _image; // Selected product image

  // Optional mapping logic (unused in dropdown, but useful fallback)
  int mapCategoryToId(String categoryName) {
    switch (categoryName) {
      case "Lotion":
        return 1;
      case "Shampoo":
        return 2;
      case "Essential Oils":
        return 3;
      default:
        return 1;
    }
  }

  // Method to allow user to select an image from gallery
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path); // Convert picked file into File
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories(); // Fetch category data on screen load
  }

  // Load categories from backend using CategoryService
  void loadCategories() async {
    try {
      categories = await CategoryService.getCategories(); // Get categories list
    } finally {
      setState(() {
        isLoadingCategories = false; // Remove loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino(); // Check current language setting
    final backgroundModel = Provider.of<Backgroundmodel>(context); // Get theme colors

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundModel.appBar,
        title: Text(
          isFilipino ? "Magdagdag ng Bagong Produkto" : 'Add New Product',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Go back to previous screen
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Product image upload
            Text(
              isFilipino
                  ? "Magdagdag ng mga larawan ng produkto"
                  : "Add product images",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              isFilipino
                  ? "Magdagdag ng hanggang 5 larawan. Ang unang larawan ang ipapakita."
                  : "Add up to 5 images. First image will be highlighted.",
            ),
            SizedBox(height: 10),
            // Display selected image or an "add" icon
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add, size: 40, color: Colors.grey),
                    )
                  : Image.file(_image!,
                      height: 80, width: 80, fit: BoxFit.cover),
            ),

            SizedBox(height: 20),

            // Section: Product details
            Text(
              isFilipino ? "Mga detalye ng produkto" : "Product details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Dropdown for selecting category
            isLoadingCategories
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: isFilipino
                          ? "Pumili ng kategorya ng produkto"
                          : "Select product category",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(), // Set value to category ID
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value; // Save selected category
                      });
                    },
                  ),

            SizedBox(height: 10),

            // Product name input
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: isFilipino ? "Pangalan ng produkto" : "Product name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // Product description input
            TextField(
              controller: productDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: isFilipino
                    ? "Deskripsyon ng produkto"
                    : "Product description",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // Product price input
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isFilipino ? "Presyo" : "Price",
                border: OutlineInputBorder(),
              ),
            ),

            Spacer(),

            // Action Buttons: Cancel & Add Product
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel and go back
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundModel.secondBtn,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isFilipino ? "Kanselahin" : "Cancel"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check for empty fields
                      if (productNameController.text.isEmpty ||
                          productDescriptionController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(isFilipino
                                  ? "Pakitapos ang lahat ng fields."
                                  : "Please complete all fields.")),
                        );
                        return;
                      }

                      // Get user ID from SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt('user_id');
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User not logged in.")),
                        );
                        return;
                      }

                      // Try to submit the product using the service class
                      try {
                        await CreateNewProductService.addProduct(
                          name: productNameController.text,
                          description: productDescriptionController.text,
                          price: priceController.text,
                          categoryId: int.parse(selectedCategory!),
                          userId: userId,
                          image: _image, // optional image
                        );

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(isFilipino
                                  ? "Matagumpay na naidagdag ang produkto!"
                                  : "Product added successfully!")),
                        );

                        Navigator.pop(context); // Go back after adding
                      } catch (e) {
                        // Handle failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(isFilipino
                                  ? "Nangyaring magkamali, pakisubukang muli."
                                  : "An error occurred, please try again.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isFilipino ? "Idagdag" : "Add"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
