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
  final RxList<Map<String, dynamic>> subCategories = <Map<String, dynamic>>[].obs;

  Future<void> fetchProducts(int storeId, {int? subCategoryId}) async {
    try {
      isLoading(true);
      error('');
      
      String url = subCategoryId == null 
          ? 'http://man.runasp.net/api/Product/All?storeId=$storeId'
          : 'http://man.runasp.net/api/Product/GetProductsByStoreAndProductCategories?storeId=$storeId&storeProductCategoryI=$subCategoryId';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          products.assignAll(
            (jsonData['data'] as List).map((e) => Product.fromJson(e)).toList()
          );
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

  Future<void> fetchSubCategories(int storeId, String categoryName) async {
    try {
      String apiUrl = categoryName == 'الكل'
          ? 'http://man.runasp.net/api/StoreCategory/GetStoreAllSubCategoryIdAndName?storeId=$storeId'
          : 'http://man.runasp.net/api/StoreCategory/GetStoreSubCategoryIdAndName?storeId=$storeId&storeCategoryName=$categoryName';

      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["isSuccess"] == true) {
          subCategories.assignAll(
            (jsonResponse["data"] as List<dynamic>).map((item) => {
              "id": item["id"],
              "name": item["name"],
            }).toList()
          );
        } else {
          throw Exception("Error: ${jsonResponse["message"]}");
        }
      } else {
        throw Exception("Failed to load: ${response.statusCode}");
      }
    } catch (e) {
      subCategories.clear();
      rethrow;
    }
  }

  void selectCategory(String category, int storeId) {
    selectedCategory.value = category;
    selectedSubCategory.value = '';
    if (category == 'الكل') {
      fetchProducts(storeId);
    } else {
      fetchSubCategories(storeId, category);
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