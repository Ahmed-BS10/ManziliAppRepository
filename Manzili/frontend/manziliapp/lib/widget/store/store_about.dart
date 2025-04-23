import 'package:flutter/material.dart';

class StoreAbout extends StatelessWidget {
  const StoreAbout(
      {Key? key, required this.description, required this.bookTime})
      : super(key: key);

  final String description;
  final String bookTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Right-aligned for Arabic
        children: [
          const Text(
            ':عن المتجر',
            style: TextStyle(
              color: Color(0xFF1548C7),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 17, height: 1.5),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),

          // Delivery time
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                bookTime,
                style: const TextStyle(fontSize: 19, color: Color(0xFF1548C7)),
                textAlign: TextAlign.right,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.access_time, color: Color(0xFF1548C7), size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
