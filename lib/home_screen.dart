import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_card.dart';
import 'product.dart';
import 'create_new_product.dart'; // Corrected import for CreateNewProduct
import 'user_preference.dart';
import 'editproduct_screen.dart';  // Import for EditProductScreen
import 'myproduct_screen.dart';   // Import for MyProductsScreen
import '/models/background_model.dart';
import '/models/language_model.dart';

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
    final String myProductsText = isFilipino ? "Aking mga Produkto" : "My Products";
    final String editProductText = isFilipino ? "I-edit ang Produkto" : "Edit Product";

    // Replace with dynamic data or API call
    final List<Product> popularProducts = [
      Product(id: 1, name: "Body Lotion", description: "A nourishing body lotion", price: 29.99, categoryId: 1, userId: 1, imagePath: "images/lotion.jpg"),
      Product(id: 2, name: "Skin Oil Serum", description: "A hydrating skin oil serum", price: 29.99, categoryId: 1, userId: 1, imagePath: "images/serum.jpg"),
      Product(id: 3, name: "TRESemme Shampoo", description: "A refreshing shampoo", price: 29.99, categoryId: 2, userId: 1, imagePath: "images/treseme.jpg"),
    ];

    final List<Product> recentProducts = [
      Product(id: 4, name: "Natural Argan Oil", description: "Pure natural argan oil", price: 49.99, categoryId: 3, userId: 1, imagePath: "images/argan_oil.jpg"),
      Product(id: 5, name: "Natural Lip Oil", description: "Moisturizing lip oil", price: 49.99, categoryId: 3, userId: 1, imagePath: "images/lip_oil.jpeg"),
      Product(id: 6, name: "TRESemme Shampoo", description: "Refreshing shampoo for hair", price: 49.99, categoryId: 2, userId: 1, imagePath: "images/treseme.jpg"),
    ];

    final int userId = 1; // Replace with dynamic user ID or from your authentication provider

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
            _buildDrawerListTile(context, createProductText, Icons.add_circle_outline, () {
              // Corrected navigation to CreateNewProductScreen
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewProduct()));
            }),
            _buildDrawerListTile(context, editProductText, Icons.edit, () {
              // Navigate to EditProductScreen (example with a popular product)
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: popularProducts[0])));
            }),
            _buildDrawerListTile(context, userPreferencesText, Icons.settings, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPreferencePage()));
            }),
            _buildDrawerListTile(context, myProductsText, Icons.list, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyProductsScreen(userId: userId)));
            }),
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
                      return _buildProductCard(popularProducts[index], itemWidth, context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(recentText, () {}),
                const SizedBox(height: 10),
                Column(
                  children: recentProducts
                      .map((product) => _buildProductCard(product, screenWidth * 0.9, context))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, double itemWidth, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(product: product),
        ),
      ),
      child: ProductCardWidget(product: product, width: itemWidth),
    );
  }

  Widget _buildCategoryButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.black))),
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

  Widget _buildDrawerListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
