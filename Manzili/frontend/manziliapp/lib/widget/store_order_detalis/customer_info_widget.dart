import 'package:flutter/material.dart';
import 'package:manziliapp/model/customer.dart';

class CustomerInfoWidget extends StatelessWidget {
  final Customer customer;
  final String orderId;
  final String orderDate;

  const CustomerInfoWidget({
    super.key,
    required this.customer,
    required this.orderId,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'رقم الطلب: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(orderId),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF2962FF),
                    radius: 16,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    customer.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                'تاريخ الطلب: ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                orderDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            icon: Icons.phone,
            text: customer.phone,
            onTap: () {},
            buttonText: 'اتصال',
          ),
          const SizedBox(height: 8),
          _buildContactRow(
            icon: Icons.email,
            text: customer.email,
            onTap: () {},
            buttonText: 'إرسال',
          ),
          const SizedBox(height: 8),
          _buildContactRow(
            icon: Icons.location_on,
            text: customer.address,
            onTap: () {},
            buttonText: 'تفاصيل',
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(80, 36),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            side: const BorderSide(color: Color(0xFF2962FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(color: Color(0xFF2962FF), fontSize: 13),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(text),
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: const Color(0xFF2962FF)),
            ],
          ),
        ),
      ],
    );
  }
}
