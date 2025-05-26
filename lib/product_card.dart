import 'package:flutter/material.dart';
import 'product.dart';
import 'config.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final double width;

  const ProductCardWidget(
      {super.key, required this.product, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailScreen when tapped
        Navigator.pushNamed(context, '/detail', arguments: product);
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  (product.imagePath != null && product.imagePath!.isNotEmpty)
                      ? Image.network(
                          // Build the full image URL from AppConfig.baseUrl
                          '${AppConfig.baseUrl}/storage/${product.imagePath}',
                          height: width * 0.55, // Reduce image height
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder.png',
                              height: width * 0.55,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/placeholder.png',
                          height: width * 0.55,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
            ),
            const SizedBox(height: 8),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Product Price
            Text(
              "\$${product.price}",
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
