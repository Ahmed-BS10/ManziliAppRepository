import 'package:flutter/material.dart';
import 'package:manziliapp/CustomerViews/widget/product/QuantityButton.dart';

class ProductNameAndQuantity extends StatelessWidget {
  final String name;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductNameAndQuantity({
    Key? key,
    required this.name,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Quantity Selector
        Row(
          children: [
            QuantityButton(
              icon: '+',
              onTap: onIncrement,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                quantity.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            QuantityButton(
              icon: '-',
              onTap: onDecrement,
            ),
          ],
        ),

        // Product Name
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1548c7),
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}
