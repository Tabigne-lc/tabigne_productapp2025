import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_card.dart';
import 'product.dart';
import 'create_new_product.dart';
import 'user_preference.dart';
import 'background_model.dart';
import 'language_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);

    final themeColor = backgroundModel.accent;

    final bool isFilipino = languageModel.isFilipino();

    final String popularText = isFilipino ? "Popular na mga Produkto" : "Popular Products";
    final String recentText = isFilipino ? "Kamakailang Produkto" : "Recent Products";
    final String createProductText = isFilipino ? "Lumikha ng Produkto" : "Create Product";
    final String userPreferencesText = isFilipino ? "Mga Setting ng User" : "User Preferences";

    final List<Product> popularProducts = [
      Product(name: "Body Lotion", price: 29.99, imageUrl: "images/lotion.jpg", rating: 4.9, reviewCount: 278),
      Product(name: "Skin Oil Serum", price: 29.99, imageUrl: "images/serum.jpg", rating: 4.9, reviewCount: 278),
      Product(name: "TRESemme Shampoo", price: 29.99, imageUrl: "images/treseme.jpg", rating: 4.9, reviewCount: 278),
    ];

    final List<Product> recentProducts = [
      Product(name: "Natural Argan Oil", price: 49.99, imageUrl: "images/argan_oil.jpg", rating: 4.9, reviewCount: 278),
      Product(name: "Natural Lip Oil", price: 49.99, imageUrl: "images/lip_oil.jpeg", rating: 4.9, reviewCount: 289),
      Product(name: "TRESemme Shampoo", price: 49.99, imageUrl: "images/treseme.jpg", rating: 4.9, reviewCount: 289),
    ];

    return Scaffold(
      backgroundColor: backgroundModel.background,
      appBar: AppBar(
        title: const Text("Beauty Store"),
        backgroundColor: backgroundModel.appBar,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: backgroundModel.drawerHeader),
              child: const Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(createProductText),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProductScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(userPreferencesText),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPreferencePage()));
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double itemWidth = screenWidth * 0.4;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryButton("Serum", backgroundModel.button),
                      const SizedBox(width: 10),
                      _buildCategoryButton("Cosmetics", backgroundModel.button),
                      const SizedBox(width: 10),
                      _buildCategoryButton("Facial Wash", backgroundModel.button),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(popularText, () {}),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularProducts.length,
                    itemBuilder: (ctx, index) {
                      final product = popularProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/detail', arguments: product),
                        child: ProductCardWidget(product: product, width: itemWidth),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(recentText, () {}),
                const SizedBox(height: 10),
                Column(
                  children: recentProducts
                      .map((product) => GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/detail', arguments: product),
                            child: _buildRecentProductCard(product, screenWidth, backgroundModel),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       
        
        
      ],
    );
  }

  Widget _buildRecentProductCard(Product product, double screenWidth, Backgroundmodel backgroundModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundModel.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(product.imageUrl, height: screenWidth * 0.2),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: backgroundModel.ratingColor, size: 18),
                    Text(" ${product.rating} [${product.reviewCount} reviews]"),
                  ],
                ),
                Text("\$${product.price}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
    );
  }
}
