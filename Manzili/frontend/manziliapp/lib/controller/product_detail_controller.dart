import 'package:get/get.dart';
import 'package:manziliapp/model/full_producta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailController extends GetxController {
  // تعريف البيانات مع كمية ابتدائية تساوي 1
  var product = ProductData(
    id: 0,
    name: '',
    price: 0.0,
    description: '',
    state: '',
    quantity: 1,
    storeName: '',
    storeImage: '',
    images: [],
  ).obs;

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  // متغير لتحديد التبويب الحالي: 0 = تفاصيل المنتج ، 1 = تقييمات المنتج
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

  /// السعر الإجمالي يعتمد على سعر الوحدة وعدد القطع
  double get totalPrice => product.value.price * product.value.quantity;

  /// تحديث الكمية عبر استخدام copyWith لتغيير القيمة فقط
  void updateQuantity(int quantity) {
    // ضمان أن الكمية لا تقل عن 1
    product.value = product.value.copyWith(quantity: quantity < 1 ? 1 : quantity);
  }

  void updateTabIndex(int index) {
    selectedTabIndex.value = index;
  }
}
