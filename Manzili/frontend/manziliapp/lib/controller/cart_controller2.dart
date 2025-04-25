import 'package:get/get.dart';
import 'package:manziliapp/view/cart_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController2 extends GetxController {
  final RxMap<int, int> _cartTotalPrices = <int, int>{}.obs;

  Future<void> saveTotalPrice(int cartId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('total_price_$cartId', _cartTotalPrices[cartId] ?? 0);
    } catch (e) {
      print('Error saving total price: $e');
    }
  }

  Future<void> loadTotalPrice(int cartId, List<GetProductCard> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getInt('total_price_$cartId');
      
      if (products.isEmpty) {
        _cartTotalPrices[cartId] = 0;
      } else {
        _cartTotalPrices[cartId] = savedValue ?? 0;
      }
      
      await saveTotalPrice(cartId);
    } catch (e) {
      print('Error loading total price: $e');
      _cartTotalPrices[cartId] = 0;
    }
  }

  void calculateTotalPrice(int cartId, List<GetProductCard> products) {
    final total = products.isEmpty
        ? 0
        : products.fold(0, (sum, item) => sum + (item.price * item.quantity));
    _cartTotalPrices[cartId] = total;
    saveTotalPrice(cartId);
  }

  int getTotalPrice(int cartId) => _cartTotalPrices[cartId] ?? 0;

  Future<void> clearCart(int cartId) async {
    _cartTotalPrices.remove(cartId);
    await saveTotalPrice(cartId);
  }
}