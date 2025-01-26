import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';

class BusinessInfoPage extends StatelessWidget {
  const BusinessInfoPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: pColor,
              ),
            )),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Business Name'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Category Of Work'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Business Address'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Short Description About Your Work'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Upload Your Business Image'),
        SizedBox(height: 10),
        PasswordTextField(hintText: ' '),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'تاكيد كلمة السر'),
      ],
    );
  }
}
