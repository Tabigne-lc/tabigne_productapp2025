import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_card.dart';
import 'product.dart';
import 'create_new_product.dart';
import 'user_preference.dart';
import 'editproduct_screen.dart'; // Import for EditProductScreen
import 'myproduct_screen.dart'; // Import for MyProductsScreen
import '/models/background_model.dart';
import '/models/language_model.dart';
import 'product_service.dart';
import 'category_service.dart'; // Import for CategoryService
import 'categories_screen.dart'; // Import for CategoriesScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  int? userId;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
    _loadUserId();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id != null && id != userId) {
      setState(() {
        userId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);

    final themeColor = backgroundModel.accent;
    final bool isFilipino = languageModel.isFilipino();

    final String createProductText =
        isFilipino ? "Lumikha ng Produkto" : "Create Product";
    final String userPreferencesText =
        isFilipino ? "Mga Setting ng User" : "User Preferences";
    final String myProductsText =
        isFilipino ? "Aking mga Produkto" : "My Products";

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
              child: const Text("Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildDrawerListTile(
                context, createProductText, Icons.add_circle_outline, () {
              // Corrected navigation to CreateNewProductScreen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateNewProduct()));
            }),
            _buildDrawerListTile(context, userPreferencesText, Icons.settings,
                () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserPreferencePage()));
            }),
            _buildDrawerListTile(context, myProductsText, Icons.list, () {
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProductsScreen(userId: userId!),
                  ),
                );
              }
            }),
            // Logout button
            _buildDrawerListTile(context, 'Logout', Icons.logout, () async {
              final prefs = await SharedPreferences.getInstance();
              // Call API logout endpoint
              final url = Uri.parse('${AppConfig.baseUrl}/api/auth/logout');
              try {
                await http.post(url, headers: {'Accept': 'application/json'});
              } catch (_) {}
              await prefs.clear();
              if (!mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            }),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = List<Product>.from(snapshot.data!);
          products.shuffle();
          final bestSellers = products.take(8).toList();
          products.shuffle();
          final trending = products.take(4).toList();
          products.shuffle();
          final newArrivals = products.take(3).toList();
          products.shuffle();
          final staffPicks = products.take(4).toList();
          products.shuffle();
          final featured = products.take(3).toList();

          double screenWidth = MediaQuery.of(context).size.width;
          double itemWidth = screenWidth * 0.4;

          // Fetch categories and show them in the horizontal list
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: CategoryService.getCategories(),
            builder: (context, catSnapshot) {
              if (catSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (catSnapshot.hasError) {
                return Center(child: Text('Error: \\${catSnapshot.error}'));
              } else if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }
              final categories = catSnapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return _buildCategoryButton(
                            cat['name'],
                            backgroundModel.button,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoriesScreen(
                                    initialCategoryId: cat['id'],
                                    initialCategoryName: cat['name'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Best Sellers', () {}),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240, // Increased from 220 to prevent overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: bestSellers.length,
                        itemBuilder: (ctx, index) {
                          return _buildProductCard(
                              bestSellers[index], itemWidth, context);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Trending Now', () {}),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final gridItemWidth = (constraints.maxWidth - 10) / 2;
                        final gridItemHeight =
                            gridItemWidth / 0.85; // Increase height (was 1.2)
                        return SizedBox(
                          height: gridItemHeight * 2 + 10, // 2 rows + spacing
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.85, // Make cards taller
                            ),
                            itemCount:
                                trending.length > 4 ? 4 : trending.length,
                            itemBuilder: (ctx, index) {
                              return _buildProductCard(
                                  trending[index], gridItemWidth, context);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('New Arrivals', () {}),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240, // Increased from 220 to prevent overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newArrivals.length,
                        itemBuilder: (ctx, index) {
                          return _buildProductCard(
                              newArrivals[index], itemWidth, context);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Staff Picks', () {}),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final gridItemWidth = (constraints.maxWidth - 10) / 2;
                        final gridItemHeight =
                            gridItemWidth / 0.85; // Increase height (was 1.2)
                        return SizedBox(
                          height: gridItemHeight * 2 + 10, // 2 rows + spacing
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.85, // Make cards taller
                            ),
                            itemCount:
                                staffPicks.length > 4 ? 4 : staffPicks.length,
                            itemBuilder: (ctx, index) {
                              return _buildProductCard(
                                  staffPicks[index], gridItemWidth, context);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Featured', () {}),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240, // Increased from 220 to prevent overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        itemBuilder: (ctx, index) {
                          return _buildProductCard(
                              featured[index], itemWidth, context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
      Product product, double itemWidth, BuildContext context) {
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

  Widget _buildCategoryButton(String text, Color color,
      {VoidCallback? onTap, bool selected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: selected ? Colors.pink[50] : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          border:
              selected ? Border.all(color: Colors.pinkAccent, width: 2) : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(Icons.category,
                color: selected ? Colors.pinkAccent : Colors.grey[600],
                size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.pinkAccent : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
