import 'package:flutter/material.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 170),
      child: InkWell(
        onTap: () {},
        child: Text(
          'نسيت كلمة السر؟',
          style: TextStyle(fontSize: 14, color: Color(0xFF1548C7), fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
