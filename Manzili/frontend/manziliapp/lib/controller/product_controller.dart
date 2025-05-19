import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/model/product.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxString selectedSubCategory = ''.obs;
  final RxList<Map<String, dynamic>> subCategories =
      <Map<String, dynamic>>[].obs;

  Future<void> fetchProducts(int storeId, {int? subCategoryId}) async {
    try {
      isLoading(true);
      error('');

      String url = subCategoryId == null
          ? 'https://localhost:7175/api/Product/GetStoreProducts?$storeId'
          : 'https://localhost:7175/api/Product/All?$storeId&productCategoryId = 10';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          products.assignAll((jsonData['data'] as List)
              .map((e) => Product.fromJson(e))
              .toList());
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      products.clear();
    } finally {
      isLoading(false);
    }
  }

  void selectCategory(String category, int storeId) {
    selectedCategory.value = category;
    selectedSubCategory.value = '';
    if (category == 'الكل') {
      fetchProducts(storeId);
    }
  }

  void selectSubCategory(String subCategoryName, int storeId) {
    selectedSubCategory.value = subCategoryName;
    final subCategoryId = subCategories.firstWhere(
      (sub) => sub["name"] == subCategoryName,
      orElse: () => {"id": null},
    )["id"];
    if (subCategoryId != null) {
      fetchProducts(storeId, subCategoryId: subCategoryId);
    }
  }
}
