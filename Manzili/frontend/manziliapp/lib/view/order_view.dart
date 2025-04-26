import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/view/order_detalis_view.dart';

// Order Model
class Order {
  final int id;
  final String numberOrder;
  final String storeName;
  final String createdAt;
  final String status;
  final int totalPrice;
  final int numberOfProducts;

  Order({
    required this.id,
    required this.numberOrder,
    required this.storeName,
    required this.createdAt,
    required this.status,
    required this.totalPrice,
    required this.numberOfProducts,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      numberOrder: json['numberOrder'],
      storeName: json['storeName'],
      createdAt: json['createdAt'],
      status: json['statu'],
      totalPrice: json['totlaPrice'],
      numberOfProducts: json['numberOfProducts'],
    );
  }
}

// Orders Controller
class OrdersController {
  Future<List<Order>> fetchOrders(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isSuccess'] == true) {
          final List<dynamic> data = responseData['data'];
          if (data.isEmpty) {
            debugPrint('No orders found.');
            return [];
          }
          return data.map((json) => Order.fromJson(json)).toList();
        } else if (responseData['message'] == 'there are no Order') {
          debugPrint('No orders found: ${responseData['message']}');
          return [];
        } else {
          debugPrint('Error: ${responseData['message']}');
          return [];
        }
      } else {
        debugPrint('Failed to load orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }

  Future<List<Order>> getDeliveredOrders(int userId) async {
    final url =
        'http://man.runasp.net/api/Orders/GetDeliveredOrdersByUserId?userId=$userId';
    return await fetchOrders(url);
  }

  Future<List<Order>> getInProgressOrders(int userId) async {
    final url =
        'http://man.runasp.net/api/Orders/GetUnDeliveredOrdersByUserId?userId=$userId';
    return await fetchOrders(url);
  }
}

// Reusable Text Row Widget
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

// Main Widget Code
class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
 
  final OrdersController _controller = OrdersController();
  bool _showDelivered = true;
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint('User ID: '); // Print the userId
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _orders = _showDelivered
          ? await _controller.getDeliveredOrders(Get.find<UserController>().userId.value)
          : await _controller.getInProgressOrders(Get.find<UserController>().userId.value);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() {
        _orders = []; // Clear the orders list if there's an error
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'الطلبات',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildTabToggle(),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _orders.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد طلبات حالياً',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              return OrderCard(order: _orders[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTab('تم توصيلها', _showDelivered, () {
            setState(() {
              _showDelivered = true;
            });
            _fetchOrders();
          }),
          _buildTab('قيد المعالجة', !_showDelivered, () {
            setState(() {
              _showDelivered = false;
            });
            _fetchOrders();
          }),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.horizontal(
            right:
                title == 'تم توصيلها' ? const Radius.circular(20) : Radius.zero,
            left: title == 'قيد المعالجة'
                ? const Radius.circular(20)
                : Radius.zero,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.year}/${parsedDate.month}/${parsedDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrderDetailsView()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(
                label: ' رقم الطلب', value: order.numberOrder, isBold: true),
            const SizedBox(height: 4),
            Text(
              'تم الطلب من متجر ${order.storeName}: ${_formatDate(order.createdAt)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 24),
            InfoRow(
              label: ' الحالة',
              value: order.status,
              valueColor:
                  order.status == 'Delivered' ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 8),
            InfoRow(
              label: ' المنتجات',
              value: 'تم شراء ${order.numberOfProducts} منتج',
            ),
            const SizedBox(height: 8),
            InfoRow(
              label: ' السعر',
              value: '\$${order.totalPrice.toStringAsFixed(2)}',
              isBold: true,
              valueColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
