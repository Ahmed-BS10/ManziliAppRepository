import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';

class RegisterText extends StatelessWidget {
  const RegisterText();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'إنشاء حساب',
            style: TextStyle(
              color: pColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          'ليس لديك حساب ؟  ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
