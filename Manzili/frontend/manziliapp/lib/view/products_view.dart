import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/product_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _productController.fetchProducts(widget.storeid);
    if (!widget.categoryNames.contains('الكل')) {
      widget.categoryNames.add('الكل');
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
            selectedCategory: _productController.selectedCategory.value,
            onCategorySelected: (category) {
              _productController.selectCategory(category, widget.storeid);
              setState(() {}); // Ensure UI updates when category changes
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
