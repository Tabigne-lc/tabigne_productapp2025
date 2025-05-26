import 'package:flutter/material.dart';
import 'category_service.dart';
import 'product_service.dart';
import 'product.dart';
import 'product_card.dart';
import '/models/background_model.dart';
import '/models/language_model.dart';
import 'package:provider/provider.dart';
import 'config.dart';

class CategoriesScreen extends StatefulWidget {
  final int initialCategoryId;
  final String initialCategoryName;
  const CategoriesScreen(
      {super.key,
      required this.initialCategoryId,
      required this.initialCategoryName});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late int selectedCategoryId; // Holds the currently selected category ID
  late String selectedCategoryName; // Holds the name of the selected category
  late Future<List<Map<String, dynamic>>> _categoriesFuture; // Future to load categories
  int _currentPage = 1; // Tracks the current page number for pagination
  bool _isLoadingMore = false; // Prevents multiple fetches at the same time
  bool _hasMore = true; // Indicates if there are more products to fetch
  List<Product> _products = []; // List of loaded products
  final ScrollController _scrollController = ScrollController(); // Controls scroll for infinite loading

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategoryId;
    selectedCategoryName = widget.initialCategoryName;
    _categoriesFuture = CategoryService.getCategories(); // Fetch categories when the screen loads
    _fetchInitialProducts(); // Fetch initial products for the selected category
    _scrollController.addListener(_onScroll); // Listen for scroll to implement infinite scrolling
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose scroll controller to avoid memory leaks
    super.dispose();
  }

  void _fetchInitialProducts() async {
    setState(() {
      _currentPage = 1; // Reset to first page
      _products = []; // Clear previous products
      _hasMore = true;
      _isLoadingMore = false;
    });
    await _fetchProductsPage(); // Fetch the first page of products
  }

  Future<void> _fetchProductsPage() async {
    if (!_hasMore || _isLoadingMore) return; // Exit if already loading or no more data
    setState(() {
      _isLoadingMore = true; // Indicate loading has started
    });
    try {
      final result = await ProductService.fetchProductsByCategoryPaginated(
          selectedCategoryId, _currentPage); // Fetch paginated products
      setState(() {
        _products.addAll(result['products']); // Add fetched products to the list
        _hasMore = result['hasMore']; // Update if more products are available
        _isLoadingMore = false;
        _currentPage++; // Move to next page for future fetches
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false; // Stop loading in case of error
      });
    }
  }

  void _onCategorySelected(int id, String name) {
    setState(() {
      selectedCategoryId = id;
      selectedCategoryName = name; // Update the selected category
    });
    _fetchInitialProducts(); // Refetch products based on new category
  }

  void _onScroll() {
    // Check if the user scrolled near the bottom and load more products if available
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _fetchProductsPage();
    }
  }

  // Builds a custom animated button for category selection
  Widget _buildCategoryButton(String text, bool selected,
      {VoidCallback? onTap}) {
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

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context); // Used to get background color settings
    final languageModel = Provider.of<LanguageModel>(context); // Used to toggle between languages
    final isFilipino = languageModel.isFilipino(); // Check if current language is Filipino

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isFilipino ? 'Mga Produkto ng Kategorya' : 'Category Products'), // AppBar title depends on language
        backgroundColor: backgroundModel.appBar,
      ),
      backgroundColor: backgroundModel.background,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _categoriesFuture, // Future to fetch categories
        builder: (context, catSnapshot) {
          if (catSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loader while waiting
          } else if (catSnapshot.hasError) {
            return Center(child: Text('Error: \\${catSnapshot.error}')); // Show error if any
          } else if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.')); // Handle empty data
          }
          final categories = catSnapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10), // Space between buttons
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final bool isSelected = cat['id'] == selectedCategoryId;
                    return _buildCategoryButton(
                      cat['name'],
                      isSelected,
                      onTap: () => _onCategorySelected(cat['id'], cat['name']),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  selectedCategoryName, // Display selected category name
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController, // Attach scroll controller
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _products.length + (_isLoadingMore ? 1 : 0), // Add extra item for loader
                  itemBuilder: (context, index) {
                    if (index < _products.length) {
                      return ProductCardWidget(
                        product: _products[index], // Show product item
                        width: (MediaQuery.of(context).size.width - 64) / 2,
                      );
                    } else {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(), // Show loader while loading more
                      ));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
