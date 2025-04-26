import 'package:flutter/material.dart';

class ShipmentAddress extends StatefulWidget {
  const ShipmentAddress({
    super.key,
    required this.onAddressSelected,
  });

  final Function(String) onAddressSelected;

  @override
  State<ShipmentAddress> createState() => _ShipmentAddressState();
}

class _ShipmentAddressState extends State<ShipmentAddress> {
  TextEditingController addressController = TextEditingController();
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_back_ios),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'عنوان الشحن',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: address.isEmpty ? 'اضف عنوان الشحن' : address,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    setState(() {
                      address = value;
                    });
                    widget.onAddressSelected(value); // Notify parent widget
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
