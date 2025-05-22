import 'order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/order.dart';

class MockData {
  static Future<List<Order>> getNewOrders() async {
    final url = Uri.parse('http://man.runasp.net/api/Store/GetStoreOrdersInNewStatus?storeId=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // If the API returns a list, parse each; if single object, wrap in list
      final ordersJson = data is List ? data : [data];

      return ordersJson.map<Order>((jsonOrder) {
        return Order(
          customerPhone: jsonOrder['customerPhoneNumber'],
          id: jsonOrder['id'].toString(),
          customerName: jsonOrder['customerName'] ?? '',
          customerAvatar: '', // No avatar in API
          customerEmail: jsonOrder['customerEmail'] ?? '',
          customerAddress: jsonOrder['customerAddress'] ?? '',
          status: OrderStatus.new_order,
          date: DateTime.tryParse(jsonOrder['createdAt'] ?? '') ?? DateTime.now(),
          notes: jsonOrder['note'] ?? '',
          items: (jsonOrder['orderProducts'] as List)
              .map((p) => OrderItem(
                    id: p['id']?.toString() ?? '',
                    name: p['name'] ?? '',
                    price: (p['price'] as num?)?.toDouble() ?? 0.0,
                    quantity: p['count'] ?? 0,
                  ))
              .toList(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load new orders');
    }
  }

  static Future<List<Order>> getCurrentOrders() async {
    final url = Uri.parse('http://man.runasp.net/api/Store/GetStoreOrdersInWorkStatus?storeId=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final ordersJson = data is List ? data : [data];

      return ordersJson.map<Order>((jsonOrder) {
        return Order(
          customerPhone: jsonOrder['customerPhoneNumber'],
          id: jsonOrder['id'].toString(),
          customerName: jsonOrder['customerName'] ?? '',
          customerAvatar: '', // No avatar in API
          customerEmail: jsonOrder['customerEmail'] ?? '',
          customerAddress: jsonOrder['customerAddress'] ?? '',
          status: OrderStatus.in_progress, // or map from jsonOrder['status'] if needed
          date: DateTime.tryParse(jsonOrder['createdAt'] ?? '') ?? DateTime.now(),
          notes: jsonOrder['note'] ?? '',
          items: (jsonOrder['orderProducts'] as List)
              .map((p) => OrderItem(
                    id: p['id']?.toString() ?? '',
                    name: p['name'] ?? '',
                    price: (p['price'] as num?)?.toDouble() ?? 0.0,
                    quantity: p['count'] ?? 0,
                  ))
              .toList(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load current orders');
    }
  }

  static Future<List<Order>> getPreviousOrders() async {
    final url = Uri.parse('http://man.runasp.net/api/Store/GetStoreOrdersInPastStatus?storeId=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final ordersJson = data is List ? data : [data];

      return ordersJson.map<Order>((jsonOrder) {
        return Order(
          customerPhone: jsonOrder['customerPhoneNumber'],
          id: jsonOrder['id'].toString(),
          customerName: jsonOrder['customerName'] ?? '',
          customerAvatar: '', // No avatar in API
          customerEmail: jsonOrder['customerEmail'] ?? '',
          customerAddress: jsonOrder['customerAddress'] ?? '',
          status: OrderStatus.completed, // or map from jsonOrder['status'] if needed
          date: DateTime.tryParse(jsonOrder['createdAt'] ?? '') ?? DateTime.now(),
          notes: jsonOrder['note'] ?? '',
          items: (jsonOrder['orderProducts'] as List)
              .map((p) => OrderItem(
                    id: p['id']?.toString() ?? '',
                    name: p['name'] ?? '',
                    price: (p['price'] as num?)?.toDouble() ?? 0.0,
                    quantity: p['count'] ?? 0,
                  ))
              .toList(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load previous orders');
    }
  }
}
