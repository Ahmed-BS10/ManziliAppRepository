import 'package:flutter/material.dart';
import 'package:manziliapp/model/order.dart';

class ActionButtonsWidget extends StatelessWidget {
  final OrderStatus status;

  const ActionButtonsWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case OrderStatus.new_order:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('رفض الطلب'),
              ),
            ),
          ],
        );
      case OrderStatus.ongoing:
        return Container(
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
        );
      case OrderStatus.completed:
        return Container(
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
        );
      case OrderStatus.cancelled:
        return Container(
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
        );
      case OrderStatus.in_progress:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
