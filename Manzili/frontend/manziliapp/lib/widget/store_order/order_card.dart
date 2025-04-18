import 'package:flutter/material.dart';
import '../../model/order.dart';
import 'order_status_badge.dart';
import 'order_actions.dart';
import 'order_items_list.dart';
import 'customer_info.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onDetails;
  final VoidCallback? onProductDetails;
  final VoidCallback? onContactCustomer;

  const OrderCard({
    Key? key,
    required this.order,
    this.onAccept,
    this.onCancel,
    this.onDetails,
    this.onProductDetails,
    this.onContactCustomer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info section
          CustomerInfo(
            name: order.customerName,
            avatarUrl: order.customerAvatar,
            orderId: order.id,
            orderDate: order.date,
          ),

          // Order items list
          OrderItemsList(items: order.items),

          // Notes section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'ملاحظة: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        'زيادة تكسب وبدون أي إضافات وأيضاً...',
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'المزيد',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order status
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: OrderStatusBadge(status: order.status),
          ),

          // Order actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrderActions(
              orderStatus: order.status,
              onAccept: onAccept,
              onCancel: onCancel,
              onDetails: onDetails,
              onProductDetails: onProductDetails,
              onContactCustomer: onContactCustomer,
              documentName: order.status == OrderStatus.new_order
                  ? 'document-name.PDF'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
