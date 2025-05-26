import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';
import 'editproduct_screen.dart';
import 'config.dart';
import '/models/background_model.dart';
import 'package:provider/provider.dart';

class MyProductsScreen extends StatefulWidget {
  final int userId;

  const MyProductsScreen({super.key, required this.userId});

  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Product> _products = []; // List to hold fetched products
  final Set<int> _selectedProductIds = {}; // Stores IDs of selected products

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Load products when the screen initializes
  }

  Future<void> _fetchProducts() async {
    final response = await http
        .get(Uri.parse('${AppConfig.baseUrl}/api/products/${widget.userId}'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // API may return either a map (with a 'data' key) or a list
      final List<dynamic> data = (body is Map && body['data'] != null)
          ? body['data']
          : (body is List ? body : [body]);
      setState(() {
        _products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      // Handle error (e.g., show snackbar)
    }
  }

  Future<void> _deleteProduct(int id) async {
    // Deletes a product by its ID
    final response =
        await http.delete(Uri.parse('${AppConfig.baseUrl}/api/products/$id'));
    if (response.statusCode == 200) {
      setState(() {
        _products.removeWhere((product) => product.id == id);
        _selectedProductIds
            .remove(id); // Remove from selected IDs if applicable
      });
    } else {
      // Handle deletion error
    }
  }

  Future<void> _deleteSelectedProducts() async {
    // Ask user to confirm deletion of selected items
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Selected Products'),
        content: Text('Are you sure you want to delete the selected products?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes')),
        ],
      ),
    );
    if (confirm == true) {
      // Delete each selected product (avoid concurrent modification)
      final idsToDelete = List<int>.from(_selectedProductIds);
      for (var id in idsToDelete) {
        await _deleteProduct(id);
      }
    }
  }

  void _editSelectedProduct() {
    // Allows editing only if one product is selected
    if (_selectedProductIds.length == 1) {
      final productId = _selectedProductIds.first;
      final product = _products.firstWhere((p) => p.id == productId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(product: product),
        ),
      ).then((_) => _fetchProducts()); // Refresh after editing
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundModel =
        Provider.of<Backgroundmodel>(context); // Get background color model
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundModel.appBar,
        elevation: 2,
        actions: [
          if (_selectedProductIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.pinkAccent),
              tooltip: 'Delete Selected',
              onPressed: _deleteSelectedProducts,
            ),
          if (_selectedProductIds.length == 1)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.pinkAccent),
              tooltip: 'Edit Selected',
              onPressed: _editSelectedProduct,
            ),
        ],
      ),
      backgroundColor: backgroundModel.background,
      body: _products.isEmpty
          ? Center(
              child: Text(
                'No products found.',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              itemCount: _products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = _products[index];
                final isSelected = _selectedProductIds.contains(product.id);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.pink[50] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color:
                            isSelected ? Colors.pinkAccent : Colors.grey[300]!,
                        width: isSelected ? 2 : 1),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? Colors.pinkAccent.withOpacity(0.08)
                            : Colors.grey.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((product.imagePath ?? '').isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${AppConfig.baseUrl}/storage/${product.imagePath}',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                            ),
                          )
                        else
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image,
                                color: Colors.grey, size: 32),
                          ),
                        const SizedBox(width: 8),
                        Checkbox(
                          value: isSelected,
                          activeColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedProductIds.add(product.id);
                              } else {
                                _selectedProductIds.remove(product.id);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                      tooltip: 'Edit',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProductScreen(product: product),
                          ),
                        ).then(
                            (_) => _fetchProducts()); // Refresh after editing
                      },
                    ),
                    onLongPress: () async {
                      // Prompt user for confirmation before deleting
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: Text(
                              'Are you sure you want to delete "${product.name}"?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes',
                                    style:
                                        TextStyle(color: Colors.pinkAccent))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _deleteProduct(product.id); // Delete if confirmed
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
