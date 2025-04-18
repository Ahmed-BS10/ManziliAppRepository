import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manziliapp/widget/auhentication/business_info_page.dart';
import 'package:manziliapp/widget/auhentication/personal_info_page.dart';

// class CustomPageView extends StatelessWidget {
//   final PageController pageController;
//   const CustomPageView({
//     Key? key,
//     required this.pageController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: pageController,
//       physics: NeverScrollableScrollPhysics(),
//       children: [
//         PersonalInfoPage(),
//         BusinessInfoPage(pageController: pageController),
//       ],
//     );
//   }
// }

class CustomPageView extends StatelessWidget {
  final PageController pageController;
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController businessNameController;
  final TextEditingController bankAccountController;
  final TextEditingController categoryOfWorkController;
  final Function(File) onUserImagePicked;

  const CustomPageView({
    Key? key,
    required this.pageController,
    required this.usernameController,
    required this.phoneController,
    required this.emailController,
    required this.cityController,
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.businessNameController,
    required this.bankAccountController,
    required this.categoryOfWorkController,
    required this.onUserImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        PersonalInfoPage(
          usernameController: usernameController,
          phoneController: phoneController,
          emailController: emailController,
          cityController: cityController,
          addressController: addressController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          onImagePicked: onUserImagePicked,
        ),
        BusinessInfoPage(
          pageController: pageController,
          businessNameController: businessNameController,
          bankAccountController: bankAccountController,
        ),
      ],
    );
  }
}
