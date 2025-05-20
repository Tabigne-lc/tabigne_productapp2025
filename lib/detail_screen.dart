import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'models/background_model.dart';
import '/models/language_model.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino = languageModel.isFilipino();  // Check if the language is Filipino

    return Scaffold(
      appBar: AppBar(
        title: Text(isFilipino ? "Detalye ng Produkto" : "Details"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Product Image Section
          Container(
            height: 300,
            color: Colors.purple[100],
            child: Center(
              child: Image.asset(
                product.imagePath ?? 'assets/placeholder.png', // Use placeholder if imagePath is null
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Rating and Reviews Section (No longer needed as per changes)
                // Removed rating and review count since they were removed from Product class.

                const SizedBox(height: 10),

                // Product Description (Localized)
                Text(
                  isFilipino
                      ? "Ito ay isang premium na produkto sa skincare para mapaganda ang iyong kutis!"
                      : "This is a premium skincare product to enhance your beauty!",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Shop Now Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
                    onPressed: () {},
                    child: Text(
                      isFilipino ? "Mamili Ngayon" : "Shop Now",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
