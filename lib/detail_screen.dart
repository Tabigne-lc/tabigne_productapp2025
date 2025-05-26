import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';

import '/models/language_model.dart';

//testing
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino =
        languageModel.isFilipino(); // Check if the language is Filipino

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isFilipino ? "Detalye ng Produkto" : "Product Details",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(children: [
        // Product Image Section
        Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: product.imagePath != null
                ? Image.network(
                    product.imagePath!,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder.png',
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/placeholder.png',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "₱${product.price}",
                      style: const TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                  const SizedBox(width: 4),
                  const Text("4.8",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Text("(1.2k reviews)",
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                isFilipino ? "Deskripsyon ng Produkto" : "Product Description",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                product.description.isNotEmpty
                    ? product.description
                    : (isFilipino
                        ? "Walang deskripsyon."
                        : "No description available."),
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white),
                      label: Text(
                        isFilipino ? "Idagdag sa Cart" : "Add to Cart",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side:
                          const BorderSide(color: Colors.pinkAccent, width: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child:
                        Icon(Icons.favorite_border, color: Colors.pinkAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Comments & Ratings Section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.comment, color: Colors.pink[200]),
                  const SizedBox(width: 8),
                  Text(
                    isFilipino ? "Mga Komento at Rating" : "Comments & Ratings",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Example static comments (replace with dynamic data if available)
              _buildComment(
                username: "Jane D.",
                rating: 5,
                comment:
                    isFilipino ? "Napakagandang produkto!" : "Amazing product!",
                date: "2025-05-20",
              ),
              const SizedBox(height: 10),
              _buildComment(
                username: "Mark L.",
                rating: 4,
                comment: isFilipino ? "Sulit sa presyo." : "Worth the price.",
                date: "2025-05-18",
              ),
              const SizedBox(height: 10),
              _buildComment(
                username: "Anna S.",
                rating: 5,
                comment: isFilipino ? "Bibilhin ko ulit!" : "Will buy again!",
                date: "2025-05-15",
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_comment, color: Colors.pinkAccent),
                label: Text(
                  isFilipino ? "Magdagdag ng Komento" : "Add a Comment",
                  style: const TextStyle(color: Colors.pinkAccent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ]),
    );
  }

  Widget _buildComment({
    required String username,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(username,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              ...List.generate(
                rating,
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 16),
              ),
              ...List.generate(
                5 - rating,
                (index) => const Icon(Icons.star_border,
                    color: Colors.amber, size: 16),
              ),
              const Spacer(),
              Text(date,
                  style: const TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
