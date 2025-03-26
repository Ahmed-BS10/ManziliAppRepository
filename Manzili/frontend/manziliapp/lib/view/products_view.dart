import 'package:flutter/material.dart';
import 'package:manziliapp/model/product.dart';
import 'package:manziliapp/widget/store/category_tabs.dart';
import 'package:manziliapp/widget/store/product_card.dart';

import '../theme/app_theme.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  String _selectedCategory = 'الكل';
  String _selectedSubCategory = 'مأكولات';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'الكل',
    'مأكولات',
    'مشروبات',
    'حلويات',
    'معجنات',
    'حلويات',
  ];

  final List<String> _subCategories = [
    'مأكولات',
    'مأكولات',
    'مأكولات',
    'مأكولات',
  ];

  final List<Product> _products = Product.sampleProducts();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category tabs
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: CategoryTabs(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        ),

        // Sub-category tabs
        if (_selectedCategory != 'الكل')
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: CategoryTabs(
              categories: _subCategories,
              selectedCategory: _selectedSubCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedSubCategory = category;
                });
              },
              showMore: true,
            ),
          ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'بحث',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                // إضافة مسافة 20px من اليمين لإزاحة النص إلى اليسار
                contentPadding: EdgeInsets.fromLTRB(0, 12, 25, 12),
              ),
            ),
          ),
        ),

        // Product list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: _products[index]);
            },
          ),
        ),
      ],
    );
  }
}
