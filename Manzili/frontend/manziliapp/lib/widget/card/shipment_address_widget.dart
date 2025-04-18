import 'package:flutter/material.dart';

class ShipmentAddress extends StatefulWidget {
  const ShipmentAddress({
    super.key,
  });

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
          Icon(Icons.arrow_back_ios),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عنوان الشحن',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                // Text(
                //   'اضف عنوان الشحن',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //   ),
                // ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: address.isEmpty ? 'اضف عنوان الشحن' : address,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    setState(
                      () => address = value,
                    );
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
