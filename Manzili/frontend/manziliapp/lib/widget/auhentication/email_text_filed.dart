import 'package:flutter/material.dart';

class EmailTextFiled extends StatelessWidget {
  const EmailTextFiled(
      {super.key, this.iconData, this.onChanged, this.controller});

  final Widget? iconData;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      width: 298,
      child: TextFormField(
          textAlign: TextAlign.right,
          onChanged: onChanged,
          controller: controller,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'البريد الإلكتروني مطلوب';
          //   }

          //   if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
          //     return 'البريد الإلكتروني غير صالح';
          //   }
          //   return null;
          // },
          decoration: InputDecoration(
            prefixIcon: iconData,
            hintText: 'أدخل بريدك الإلكتروني',
            filled: true,
            fillColor: const Color(0x00f4f4f4),
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
