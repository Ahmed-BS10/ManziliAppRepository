import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/widget/auhentication/custom_password_text.dart';

class ForgotPasswordViewBody extends StatelessWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('نسيت كلمة السر'),
        EmailTextField(),
        CustomTextButton(
            onPressed: () {},
            name: 'التالي',
            fontColor: Colors.white,
            backColor: pColor)
      ],
    );
  }
}
