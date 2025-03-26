import 'package:flutter/material.dart';

class StoreContact extends StatelessWidget {
  const StoreContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Right-aligned for Arabic
        children: [
          const Text(
            ':يمكنكم التواصل معنا على',
            style: TextStyle(
              color: Color(0xFF1548C7),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),

          // Phone number 1
          _buildContactItem(
            icon: Icons.phone,
            text: '+967 7777777' ,
            color: Color(0xFF1548C7),

          ),

          const SizedBox(height: 8),

          // WhatsApp
          _buildContactItem(
            icon: Icons.call,
            text: '+967 7777777',
            color: Color(0xFF1548C7),

          ),

          const SizedBox(height: 16),

          // Social media
          const Text(
            ':أو متابعتنا على',
            style: TextStyle(
              color: Color(0xFF1548C7),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),

          // Instagram
          _buildContactItem(
            icon: Icons.camera_alt,
            text: 'ck_storeApp',
            color: Color(0xFF1548C7),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 23),
      ],
    );
  }
}

