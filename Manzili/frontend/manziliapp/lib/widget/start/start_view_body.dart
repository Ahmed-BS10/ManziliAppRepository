import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/view/login_view.dart';

class StartViewBody extends StatelessWidget {
  const StartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10),
          Image.asset('assets/image/startimg.jpg'),
          SizedBox(height: 50),
          Text(
            'اكتشف الكنوز المصنوعة منزليًا \n     ودعم إبداع العائلة مع \n           أعمال العائلة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 20),
          Text(
            'هل أنت  ؟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 20),
          CustomTextButton(
            onPressed: () {
              userType = 'customer';

              Get.to(() => LoginView());
            },
            name: 'عميل ',
            fontColor: const Color(0xFFFFFFFF),
            backColor: const Color(0xFF8E6CEF),
          ),
          SizedBox(height: 15),
          CustomTextButton(
            onPressed: () {
              userType = 'producer';
              Get.to(() => LoginView());
            },
            name: 'أسرة منتجة',
            fontColor: const Color(0xFFFFFFFF),
            backColor: const Color(0xFF8E6CEF),
          )
        ],
      ),
    );
  }
}
