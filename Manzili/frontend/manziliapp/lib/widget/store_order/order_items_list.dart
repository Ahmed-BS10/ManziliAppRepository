import 'package:flutter/material.dart';
import '../../model/order.dart';

class OrderItemsList extends StatelessWidget {
  final List<OrderItem> items;

  const OrderItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Header
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'اسم المنتج',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'السعر',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'الكمية',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'المجموع',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const Divider(),

          // Items
          ...items
              .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(item.name),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${item.quantity} قطع',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ))
              ,

          const Divider(),

          // Total
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'المجموع الكلي',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${items.fold(0, (prev, item) => prev + item.quantity)} قطع',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '\$${items.fold(0.0, (prev, item) => prev + (item.price * item.quantity)).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
