import 'package:flutter/material.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 30),
        CustomeTextFiled(hintText: 'اسمك الكامل '),
        SizedBox(height: 10),
        EmailTextFiled(),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'رقمك'),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'كلمة السر'),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'تاكيد كلمة السر'),
      ],
    );
  }
}
