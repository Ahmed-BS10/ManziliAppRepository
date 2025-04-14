import 'package:flutter/material.dart';
import 'package:manziliapp/model/product.dart';
import 'package:manziliapp/widget/store/category_tabs.dart';
import 'package:manziliapp/widget/store/product_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsView extends StatefulWidget {
  const ProductsView(
      {Key? key, required this.categoryNames, required this.storeid})
      : super(key: key);

  final List<String> categoryNames;
  final int storeid;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  String _selectedCategory = 'الكل';
  String _selectedSubCategory = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _subCategories = []; // Store id and name
  List<Product> _products = []; // Dynamically fetched products

  @override
  void initState() {
    super.initState();
    widget.categoryNames.add('الكل');
    _fetchSubCategories('الكل'); // Fetch all subcategories by default
  }

  Future<void> _fetchSubCategories(String categoryName) async {
    String apiUrl;

    if (categoryName == 'الكل') {
      apiUrl =
          'http://man.runasp.net/api/StoreCategory/GetStoreAllSubCategoryIdAndName?storeId=${widget.storeid}';
    } else {
      apiUrl =
          'http://man.runasp.net/api/StoreCategory/GetStoreSubCategoryIdAndName?storeId=${widget.storeid}&storeCategoryName=$categoryName';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["isSuccess"] == true) {
          setState(() {
            _subCategories = (jsonResponse["data"] as List<dynamic>)
                .map((item) => {
                      "id": item["id"],
                      "name": item["name"],
                    })
                .toList();
          });
        } else {
          throw Exception("Error: ${jsonResponse["message"]}");
        }
      } else {
        throw Exception("Failed to load: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
  }

  Future<void> _fetchProducts(int subCategoryId) async {
    final String apiUrl =
        'http://man.runasp.net/api/Product/GetProductsByStoreAndProductCategories?storeId=${widget.storeid}&storeProductCategoryI=$subCategoryId';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["isSuccess"] == true) {
          setState(() {
            _products = (jsonResponse["data"] as List<dynamic>)
                .map((item) => Product.fromJson(item))
                .toList();
          });
        } else {
          throw Exception("Error: ${jsonResponse["message"]}");
        }
      } else {
        throw Exception("Failed to load: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

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
            categories: widget.categoryNames,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
                _subCategories = []; // Clear subcategories while fetching
              });
              _fetchSubCategories(category);
            },
          ),
        ),

        // Sub-category tabs
        if (_subCategories.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: CategoryTabs(
              categories:
                  _subCategories.map((sub) => sub["name"] as String).toList(),
              selectedCategory: _selectedSubCategory,
              onCategorySelected: (subCategoryName) {
                setState(() {
                  _selectedSubCategory = subCategoryName;
                });
                final selectedSubCategoryId = _subCategories.firstWhere(
                  (sub) => sub["name"] == subCategoryName,
                  orElse: () => {"id": null},
                )["id"];
                if (selectedSubCategoryId != null) {
                  _fetchProducts(selectedSubCategoryId);
                }
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
              return ProductCard(
                product: _products[index],
                subCategoryId: _subCategories.firstWhere(
                  (sub) => sub["name"] == _selectedSubCategory,
                  orElse: () => {"id": null},
                )["id"],
                storeId: widget.storeid,
              );
            },
          ),
        ),
      ],
    );
  }
}
