import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'background_model.dart';
import 'language_model.dart';

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
          Container(
            height: 300,
            color: Colors.purple[100],
            child: Center(child: Image.asset(product.imageUrl, height: 180)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("\$${product.price}", style: const TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    Text(" ${product.rating} [${product.reviewCount} reviews]"),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  isFilipino 
                  ? "Ito ay isang premium na produkto sa skincare para mapaganda ang iyong kutis!" 
                  : "This is a premium skincare product to enhance your beauty!",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
                    onPressed: () {},
                    child: Text(
                      isFilipino ? "Mamili Ngayon" : "Shop Now", 
                      style: const TextStyle(color: Colors.white)
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
