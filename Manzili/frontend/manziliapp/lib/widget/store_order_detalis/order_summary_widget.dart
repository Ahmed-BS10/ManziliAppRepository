import 'package:flutter/material.dart';
import 'package:manziliapp/model/order.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;

  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('الإجمالي الفرعي'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${deliveryFee.toStringAsFixed(2)}',
              ),
              const Text('سعر التوصيل'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${discount.toStringAsFixed(2)}',
              ),
              const Text('سعر الخصم'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'الإجمالي الكلي',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(120, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  side: const BorderSide(color: Color(0xFF2962FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'طباعة الفاتورة',
                  style: TextStyle(color: Color(0xFF2962FF)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusWidget(status),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(OrderStatus status) {
    switch (status) {
      case OrderStatus.new_order:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('رفض الطلب'),
              ),
            ),
          ],
        );
      case OrderStatus.ongoing:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delivery_dining, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'تم توصيل الطلب',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        );
      case OrderStatus.completed:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'تم توصيل الطلب بنجاح',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        );
      case OrderStatus.cancelled:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'تم إلغاء الطلب',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        );
      case OrderStatus.in_progress:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
