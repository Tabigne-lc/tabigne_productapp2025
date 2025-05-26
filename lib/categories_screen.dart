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
  late int selectedCategoryId;
  late String selectedCategoryName;
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategoryId;
    selectedCategoryName = widget.initialCategoryName;
    _categoriesFuture = CategoryService.getCategories();
    _fetchInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchInitialProducts() async {
    setState(() {
      _currentPage = 1;
      _products = [];
      _hasMore = true;
      _isLoadingMore = false;
    });
    await _fetchProductsPage();
  }

  Future<void> _fetchProductsPage() async {
    if (!_hasMore || _isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final result = await ProductService.fetchProductsByCategoryPaginated(
          selectedCategoryId, _currentPage);
      setState(() {
        _products.addAll(result['products']);
        _hasMore = result['hasMore'];
        _isLoadingMore = false;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onCategorySelected(int id, String name) {
    setState(() {
      selectedCategoryId = id;
      selectedCategoryName = name;
    });
    _fetchInitialProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _fetchProductsPage();
    }
  }

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
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino = languageModel.isFilipino();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isFilipino ? 'Mga Produkto ng Kategorya' : 'Category Products'),
        backgroundColor: backgroundModel.appBar,
      ),
      backgroundColor: backgroundModel.background,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _categoriesFuture,
        builder: (context, catSnapshot) {
          if (catSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (catSnapshot.hasError) {
            return Center(child: Text('Error: \\${catSnapshot.error}'));
          } else if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
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
                      const SizedBox(width: 10),
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
                  selectedCategoryName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _products.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _products.length) {
                      return ProductCardWidget(
                        product: _products[index],
                        width: (MediaQuery.of(context).size.width - 64) / 2,
                      );
                    } else {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
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
