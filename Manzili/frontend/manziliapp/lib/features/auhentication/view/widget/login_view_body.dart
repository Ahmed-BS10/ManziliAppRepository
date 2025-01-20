import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/core/widget/custom_text_button_icon.dart';

import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_divider.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            width: 383,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/image/loginimg.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8))),
          ),
          const SizedBox(height: 20),
          Text(
            'مرحبا',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          CustomeTextFiled(
            hintText: 'أيمليك او رقمك',
          ),
          const SizedBox(height: 15),
          CustomeTextFiled(
            hintText: 'كلمة السر',
            iconData: Icon(Icons.visibility),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Text(
                  'نسيت كلمة السر؟',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextButton(
            onPressed: () {},
            name: 'تسجيل الدخول',
            radius: 23,
            fontColor: Colors.white,
            backColor: pColor,
          ),
          const SizedBox(height: 30),
          CustomDivider(),
          SizedBox(height: 15),
          CustomTextButtonIcon(
            title: 'Continue With Apple',
            icon: Icon(Icons.apple),
          ),
          SizedBox(height: 15),
          CustomTextButtonIcon(
            title: 'Continue With Google',
            icon: Icon(Icons.phone),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'أنشاء حساب',
                  style: TextStyle(
                    color: pColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
            ),
          ),
        ],
      ),
    );
  }
}
