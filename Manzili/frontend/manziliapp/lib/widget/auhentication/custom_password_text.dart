import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
  });

  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      width: 298,
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        textAlign: TextAlign.right,
        validator: (value) {
          if (value!.isEmpty) {
            return 'الحقل فارغ';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          hintText: widget.hintText,
          filled: true,
          fillColor: const Color(0x00f4f4f4),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0 * 1.5, vertical: 16.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 2, 12, 20), width: 1.5),
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: 'أدخل بريدك الإلكتروني',
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'البريد الإلكتروني مطلوب';
        }

        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
          return 'البريد الإلكتروني غير صالح';
        }
        return null;
      },
    );
  }
}
