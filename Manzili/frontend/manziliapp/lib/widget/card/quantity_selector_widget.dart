import 'package:flutter/material.dart';

class QuantitySelectorWidget extends StatefulWidget {
  const QuantitySelectorWidget({super.key});

  @override
  State<QuantitySelectorWidget> createState() => _QuantitySelectorWidgetState();
}

class _QuantitySelectorWidgetState extends State<QuantitySelectorWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(
              () {
                quantity--;
              },
            );
          },
        ),
        Text(
          '$quantity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(
              () {
                quantity++;
              },
            );
          },
        ),
      ],
    );
  }
}
