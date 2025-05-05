import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_model.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = "Oils";

  final List<String> _categories = ["Oils", "Serums", "Shampoos", "Lotions"];

  @override
  Widget build(BuildContext context) {
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino = languageModel.isFilipino();  // Check if the selected language is Filipino

    return Scaffold(
      appBar: AppBar(
        title: Text(isFilipino ? "Lumikha ng Bagong Produkto" : "Create New Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isFilipino ? "Pangalan ng Produkto" : "Product Name"),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration(hintText: isFilipino ? "Ilagay ang pangalan ng produkto" : "Enter product name"),
            ),
            const SizedBox(height: 16),

            Text(isFilipino ? "Paglalarawan ng Produkto" : "Product Description"),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration(hintText: isFilipino ? "Ilagay ang paglalarawan ng produkto" : "Enter product description"),
            ),
            const SizedBox(height: 16),

            Text(isFilipino ? "Presyo" : "Price"),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hintText: isFilipino ? "Ilagay ang presyo" : "Enter price"),
            ),
            const SizedBox(height: 16),

            Text(isFilipino ? "Kategorya" : "Category"),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration(hintText: isFilipino ? "Pumili ng kategorya" : "Select a category"),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(isFilipino ? category : category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _createProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(isFilipino ? "Lumikha ng Produkto" : "Create Product", style: const TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createProduct() {
    // Logic to handle product creation (e.g., sending data to a database)
    print("Product Created: ${_nameController.text}, Category: $_selectedCategory");
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText, // Placeholder text
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.purple.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.purple)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.purple.shade200)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
