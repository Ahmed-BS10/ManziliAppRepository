import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_divider.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/header_image.dart';
import 'package:manziliapp/features/auhentication/view/widget/register_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/social_login_buttons.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderImage(),
            const SizedBox(height: 15),
            const WelcomeText(),
            const SizedBox(height: 20),
            EmailTextFiled(),
            const SizedBox(height: 10),
            const PasswordTextField(hintText: 'كلمة السر'),
            const SizedBox(height: 10),
            const ForgotPasswordText(),
            const SizedBox(height: 15),
            CustomTextButton(
              onPressed: () {
                _validateForm();
              },
              name: 'تسجيل الدخول',
              radius: 23,
              fontColor: Colors.white,
              backColor: pColor,
            ),
            const SizedBox(height: 20),
            const CustomDivider(),
            const SizedBox(height: 15),
            const SocialLoginButtons(),
            const SizedBox(height: 10),
            RegisterText(),
          ],
        ),
      ),
    );
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      print('Successed');
    } else {
      print('Failed');
    }
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'مرحبا',
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 170),
      child: InkWell(
        onTap: () {},
        child: Text(
          'نسيت كلمة السر؟',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
