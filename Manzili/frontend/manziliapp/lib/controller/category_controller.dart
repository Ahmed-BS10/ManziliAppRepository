import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/user_controller.dart';

class CategoryController extends GetxController {
  // Reactive variables
  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategoryNames = <String>[].obs;
  var isLoading = false.obs; // Loading state

  // API endpoint
  // final String apiEndpoint =
  //     "http://man.runasp.net/api/StoreCategory/GetStoreNamesAndId";

  //API endpoint
  final String apiEndpoint =
      "http://man.runasp.net/api/Store/GetProductGategoriesByStoreId?storeId=6";

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(apiEndpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          // Extract category names and IDs from API response
          final data = jsonResponse['data'] as List;
          categories.value = data
              .map((item) => {'id': item['id'], 'name': item['name']})
              .toList();
        } else {
          Get.snackbar("Error", jsonResponse['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch categories");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle category selection
  void toggleCategorySelection(String name) {
    if (selectedCategoryNames.contains(name)) {
      selectedCategoryNames.remove(name);
    } else {
      selectedCategoryNames.add(name);
    }
  }
}
