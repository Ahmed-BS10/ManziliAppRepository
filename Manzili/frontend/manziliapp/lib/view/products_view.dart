import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/product_controller.dart';
import 'package:manziliapp/model/product.dart';
import 'package:manziliapp/view/product_detail_view.dart';
import 'package:manziliapp/widget/store/category_tabs.dart';
import 'package:manziliapp/widget/store/product_card.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    super.key,
    required this.categoryNames,
    required this.storeid,
  });

  final List<String> categoryNames;
  final int storeid;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductController _productController = Get.put(ProductController());
  final TextEditingController _searchController = TextEditingController();
  List<String> _apiCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndInitProducts();
  }

  Future<void> _fetchCategoriesAndInitProducts() async {
    // Fetch categories from API
    try {
      final response = await http.get(
        Uri.parse(
            'https://localhost:7175/api/Store/GetProductGategoriesByStoreId?storeId=${widget.storeid}'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          final data = jsonResponse['data'] as List;
          _apiCategories =
              data.map<String>((item) => item['name'] as String).toList();
          if (!_apiCategories.contains('الكل')) {
            _apiCategories.add('الكل');
          }
          setState(() {});
        }
      }
    } catch (e) {
      _apiCategories = ['الكل'];
      setState(() {});
    }
    // Fetch all products for the store (for 'الكل')
    await _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://localhost:7175/api/Product/GetStoreProducts?storeId=${widget.storeid}'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          _productController.products.assignAll(
            (jsonResponse['data'] as List)
                .map((e) => Product.fromJson(e))
                .toList(),
          );
        }
      }
    } catch (e) {
      _productController.products.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        _apiCategories.isNotEmpty ? _apiCategories : widget.categoryNames;
    return Column(
      children: [
        // Category tabs
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: CategoryTabs(
            categories: categories,
            selectedCategory: _productController.selectedCategory.value,
            onCategorySelected: (category) async {
              _productController.selectedCategory.value = category;
              _productController.selectedSubCategory.value = '';
              setState(() {});
              if (category == 'الكل') {
                await _fetchAllProducts();
              } else {
                // Find the category id from _apiCategories and fetch products for that category
                try {
                  final response = await http.get(
                    Uri.parse(
                        'https://localhost:7175/api/Store/GetProductGategoriesByStoreId?storeId=${widget.storeid}'),
                  );
                  int? categoryId;
                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    if (jsonResponse['isSuccess'] == true) {
                      final data = jsonResponse['data'] as List;
                      final match = data.firstWhere(
                        (item) => item['name'] == category,
                        orElse: () => null,
                      );
                      if (match != null) {
                        categoryId = match['id'];
                      }
                    }
                  }
                  if (categoryId != null) {
                    final prodResponse = await http.get(
                      Uri.parse(
                          'https://localhost:7175/api/Product/All?storeId=${widget.storeid}&productCategoryId=$categoryId'),
                    );
                    if (prodResponse.statusCode == 200) {
                      final prodJson = json.decode(prodResponse.body);
                      if (prodJson['isSuccess'] == true) {
                        _productController.products.assignAll(
                          (prodJson['data'] as List)
                              .map((e) => Product.fromJson(e))
                              .toList(),
                        );
                      } else {
                        _productController.products.clear();
                      }
                    } else {
                      _productController.products.clear();
                    }
                  } else {
                    _productController.products.clear();
                  }
                } catch (e) {
                  _productController.products.clear();
                }
              }
            },
          ),
        ),

        // Sub-category tabs
        Obx(() {
          if (_productController.subCategories.isNotEmpty) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: CategoryTabs(
                categories: _productController.subCategories
                    .map((sub) => sub["name"] as String)
                    .toList(),
                selectedCategory: _productController.selectedSubCategory.value,
                onCategorySelected: (subCategoryName) {
                  _productController.selectSubCategory(
                    subCategoryName,
                    widget.storeid,
                  );
                  setState(() {}); // Ensure UI updates when subcategory changes
                },
                showMore: true,
              ),
            );
          }
          return const SizedBox.shrink();
        }),

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
          child: Obx(() {
            if (_productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_productController.error.isNotEmpty) {
              return Center(child: Text(_productController.error.value));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _productController.products.length,
              itemBuilder: (context, index) {
                final product = _productController.products[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => ProductDetailView(
                          productId: product.id,
                          storeId: widget.storeid,
                        ));
                  },
                  child: ProductCard(
                    product: product,
                    subCategoryId: _productController.subCategories.isNotEmpty
                        ? _productController.subCategories.firstWhere(
                            (sub) =>
                                sub["name"] ==
                                _productController.selectedSubCategory.value,
                            orElse: () => {"id": null},
                          )["id"]
                        : null,
                    storeId: widget.storeid,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
