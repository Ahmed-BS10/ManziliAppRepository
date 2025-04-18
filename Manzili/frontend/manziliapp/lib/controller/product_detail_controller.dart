import 'package:get/get.dart';
import 'package:manziliapp/model/full_producta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailController extends GetxController {
  var product = ProductData(
    id: 0,
    name: '',
    price: 0.0,
    description: '',
    state: '',
    quantity: 1, // Product stock from API
    storeName: '',
    storeImage: '',
    images: [],
  ).obs;

  var selectedQuantity = 1.obs; // User's selected quantity
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var selectedTabIndex = 0.obs;

  Future<void> fetchProductDetails(int productId) async {
    final String apiUrl =
        'http://man.runasp.net/api/Product/Id?productId=$productId';

    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["isSuccess"] == true) {
          final productData = jsonResponse["data"];
          product.value = ProductData.fromJson(productData);
          selectedQuantity.value = 1; // Reset to 1 when loading new product
        } else {
          errorMessage.value = jsonResponse["message"];
        }
      } else {
        errorMessage.value = "Failed to load: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error fetching product details: $e";
    } finally {
      isLoading.value = false;
    }
  }

  double get totalPrice => product.value.price * selectedQuantity.value;

  void updateQuantity(int quantity) {
    selectedQuantity.value = quantity < 1 ? 1 : quantity;
  }

  void updateTabIndex(int index) {
    selectedTabIndex.value = index;
  }
}
