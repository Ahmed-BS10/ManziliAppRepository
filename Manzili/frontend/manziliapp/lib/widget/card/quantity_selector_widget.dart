// quantity_selector_widget.dart

import 'package:flutter/material.dart';

class QuantitySelectorWidget extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelectorWidget({
    Key? key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<QuantitySelectorWidget> createState() => _QuantitySelectorWidgetState();
}

class _QuantitySelectorWidgetState extends State<QuantitySelectorWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  // أضف هذه الدالة لتحديث الكمية عند تغيير القيمة الأولية
  @override
  void didUpdateWidget(QuantitySelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuantity != widget.initialQuantity) {
      setState(() {
        quantity = widget.initialQuantity;
      });
    }
  }

  void _updateQuantity(int newQty) {
    setState(() => quantity = newQty);
    widget.onQuantityChanged(newQty);
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: quantity > 1 ? () => _updateQuantity(quantity - 1) : null,
        ),
        Text(
          '$quantity',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _updateQuantity(quantity + 1),
        ),
      ],
    );
  }
}
