import 'package:flutter/material.dart';

class CustomeTextFiled extends StatelessWidget {
  const CustomeTextFiled(
      {super.key, this.hintText, this.iconData, this.onChanged});

  final String? hintText;
  final Widget? iconData;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      width: 298,
      child: TextFormField(
          textAlign: TextAlign.right,
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الحقل فارغ';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: iconData,
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xF4F4F4),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0 * 1.5, vertical: 16.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 2, 12, 20), width: 1.5),
            ),
          )),
    );
  }
}
