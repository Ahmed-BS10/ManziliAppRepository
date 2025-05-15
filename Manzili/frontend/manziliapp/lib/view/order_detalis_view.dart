import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/widget/order_details/order_info.dart';
import 'package:manziliapp/widget/order_details/order_info_card.dart';
import 'package:manziliapp/widget/order_details/payment_details.dart';
import 'package:manziliapp/widget/order_details/payment_details_card.dart';
import 'package:manziliapp/widget/order_details/section_title.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  late Future<OrderDetails> _orderDetailsFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailsFuture = _fetchOrderDetails();
  }

  Future<OrderDetails> _fetchOrderDetails() async {
    final response = await http.get(
      Uri.parse(
          'http://man.runasp.net/api/Orders/GetOrderDetails?orderId=${widget.orderId}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['isSuccess'] == true) {
        return OrderDetails.fromJson(jsonResponse['data'][0]);
      } else {
        throw Exception('Error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load order details: ${response.statusCode}');
    }
  }

  List<OrderStep> _buildSteps(String status) {
    List<String> stepTitles = ['التجهيز', 'الشحن', 'في الطريق', 'تم التسليم'];

    String normalizedStatus = status.replaceAll('_', ' ');
    int currentIndex = stepTitles.indexOf(normalizedStatus);
    if (currentIndex == -1) currentIndex = -1;

    return stepTitles.asMap().entries.map((entry) {
      return OrderStep(
        title: entry.value,
        isCompleted: entry.key <= currentIndex,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('تفاصيل الطلبات'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<OrderDetails>(
          future: _orderDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            } else {
              final orderDetails = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  OrderProgressStepper(
                    steps: _buildSteps(orderDetails.status),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'المنتجات'),
                  const SizedBox(height: 8),
                  ...orderDetails.orderProducts.map((product) {
                    return ProductCard(
                      product: ProductModel(
                        name: product.name,
                        imageUrl: 'http://man.runasp.net${product.imageUrl}',
                        quantity: product.count,
                        price: product.total.toDouble(),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  OrderInfoCard(
                    info: OrderInfo(
                      date: orderDetails.createdAt,
                      deliveryAddress: orderDetails.deliveryAddress,
                      storeName: orderDetails.storeName,
                      deliveryTimeEstimate: 'من 1 إلى 2 أيام عمل',
                    ),
                  ),
                  const SizedBox(height: 24),
                  PaymentDetailsCard(
                    payment: PaymentDetails(
                      productsTotal: orderDetails.totalPrice.toDouble(),
                      deliveryFee: orderDetails.deliveryFees.toDouble(),
                    ),
                    numberOfProducts: orderDetails.numberOfProducts,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderStep {
  final String title;
  final bool isCompleted;
  OrderStep({required this.title, required this.isCompleted});
}

class OrderProgressStepper extends StatelessWidget {
  final List<OrderStep> steps;
  const OrderProgressStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: steps.map((step) {
        return Column(
          children: [
            Icon(
              step.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: step.isCompleted ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(step.title),
          ],
        );
      }).toList(),
    );
  }
}

class ProductModel {
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;
  ProductModel({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عدد: ${product.quantity}'),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Models for API response

class OrderDetails {
  final int id;
  final String numberOrder;
  final String storeName;
  final String createdAt;
  final String status;
  final int totalPrice;
  final int numberOfProducts;
  final String deliveryAddress;
  final int deliveryFees;
  final List<OrderProduct> orderProducts;

  OrderDetails({
    required this.id,
    required this.numberOrder,
    required this.storeName,
    required this.createdAt,
    required this.status,
    required this.totalPrice,
    required this.numberOfProducts,
    required this.deliveryAddress,
    required this.deliveryFees,
    required this.orderProducts,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'],
      numberOrder: json['numberOrder'],
      storeName: json['storeName'],
      createdAt: json['createdAt'],
      status: json['status'],
      totalPrice: json['totlaPrice'],
      numberOfProducts: json['numberOfProducts'],
      deliveryAddress: json['deliveryAddress'],
      deliveryFees: json['deliveryFees'],
      orderProducts: (json['ordeProducts'] as List)
          .map((product) => OrderProduct.fromJson(product))
          .toList(),
    );
  }
}

class OrderProduct {
  final int id;
  final String name;
  final String imageUrl;
  final int total;
  final int count;

  OrderProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.total,
    required this.count,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      total: json['total'],
      count: json['count'],
    );
  }
}
