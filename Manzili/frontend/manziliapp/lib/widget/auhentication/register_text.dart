import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'register');
          },
          child: Text(
            ' إنشاء حساب',
            style: TextStyle(
              color: pColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text(
          'ليس لديك حساب ؟  ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
