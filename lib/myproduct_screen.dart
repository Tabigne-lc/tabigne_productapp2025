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
  List<Product> _products = [];
  final Set<int> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/products/${widget.userId}'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Always treat as a list of products (API returns {data: [...]})
      final List<dynamic> data = (body is Map && body['data'] != null)
          ? body['data']
          : (body is List ? body : [body]);
      setState(() {
        _products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _deleteProduct(int id) async {
    final response =
        await http.delete(Uri.parse('${AppConfig.baseUrl}/api/products/$id'));
    if (response.statusCode == 200) {
      setState(() {
        _products.removeWhere((product) => product.id == id);
        _selectedProductIds.remove(id);
      });
    } else {
      // Handle error
    }
  }

  Future<void> _deleteSelectedProducts() async {
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
      for (var id in _selectedProductIds) {
        await _deleteProduct(id);
      }
    }
  }

  void _editSelectedProduct() {
    if (_selectedProductIds.length == 1) {
      final productId = _selectedProductIds.first;
      final product = _products.firstWhere((p) => p.id == productId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(product: product),
        ),
      ).then((_) => _fetchProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        color: isSelected ? Colors.pinkAccent : Colors.grey[300]!,
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
                    leading: Checkbox(
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
                            builder: (context) => EditProductScreen(product: product),
                          ),
                        ).then((_) => _fetchProducts());
                      },
                    ),
                    onLongPress: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: Text('Are you sure you want to delete "${product.name}"?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes', style: TextStyle(color: Colors.pinkAccent))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _deleteProduct(product.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
