import 'package:flutter/material.dart';
import 'package:manziliapp/model/order.dart';
import 'package:manziliapp/model/product_order.dart';
import 'package:manziliapp/widget/store_order_detalis/customer_info_widget.dart';
import 'package:manziliapp/widget/store_order_detalis/order_note_widget.dart';
import 'package:manziliapp/widget/store_order_detalis/order_summary_widget.dart';
import 'package:manziliapp/widget/store_order_detalis/product_list_widget.dart';

import '../model/customer.dart';
import '../model/product_order.dart';

class StoreOrderDetailsView extends StatelessWidget {
  final Order order;

  const StoreOrderDetailsView({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomerInfoWidget(
                    customer: Customer(
                      name: order.customerName, 
                      phone: order.customerPhone, // Assuming 'order' has a 'customerPhone' field
                      email: order.customerEmail, // Assuming 'order' has a 'customerEmail' field
                      address: order.customerAddress, // Assuming 'order' has a 'customerAddress' field
                    ),
                    orderId: order.id,
                    orderDate: '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')}',
                  ),
                  OrderNoteWidget(note: order.notes),
                  ProductListWidget(
                    products: order.items.map((item) => ProductOrder(
                      id: item.id, // Use the correct property from OrderItem
                      name: item.name,
                      quantity: item.quantity,
                      price: item.price,
                    )).toList(),
                  ),
                  OrderSummaryWidget(
                    subtotal: order.totalPrice,
                    deliveryFee: 0, // Provide actual delivery fee if available
                    discount: 0,    // Provide actual discount if available
                    total: order.totalPrice,
                    status: order.status,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    Color backgroundColor;
    String title;

    switch (order.status) {
      case OrderStatus.new_order:
        backgroundColor = const Color(0xFF2962FF); // Royal blue color
        title = 'طلب جديد';
        break;
      case OrderStatus.ongoing:
        backgroundColor = const Color(0xFF2962FF);
        title = 'طلب حالي';
        break;
      case OrderStatus.completed:
        backgroundColor = const Color(0xFF2962FF);
        title = 'طلب مكتمل';
        break;
      case OrderStatus.cancelled:
        backgroundColor = const Color(0xFF2962FF);
        title = 'طلب ملغي';
        break;
      case OrderStatus.in_progress:
        backgroundColor = const Color(0xFF2962FF);
        title = 'قيد التنفيذ';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF2962FF), size: 16),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 32), // For balance
          ],
        ),
      ),
    );
  }
}