import 'package:flutter/material.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';

class StartViewBody extends StatelessWidget {
  const StartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          Image.asset('lib/assets/image/startimg.jpg'),
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
              Navigator.pushNamed(context, 'login');
            },
            name: 'عميل ',
            fontColor: const Color(0xFFFFFFFF),
            backColor: const Color(0xFF8E6CEF),
          ),
          SizedBox(height: 15),
          CustomTextButton(
            onPressed: () {
              userType = 'producer';
              Navigator.pushNamed(context, 'login');
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
