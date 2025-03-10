import 'package:flutter/material.dart';
import 'product.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final double width;

  const ProductCardWidget({super.key, required this.product, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(product.imageUrl, height: width * 0.6), // Responsive Image
          const SizedBox(height: 5),
          Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("\$${product.price}", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
