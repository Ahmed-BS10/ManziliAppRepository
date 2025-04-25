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
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController businessNameController;
  final TextEditingController bankAccountController;
  final TextEditingController categoryOfWorkController;
  final TextEditingController socileMediaAcountController;
  final TextEditingController descriptionController;
  final Function(File) onUserImagePicked;

  const CustomPageView({
    Key? key,
    required this.pageController,
    required this.usernameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.businessNameController,
    required this.bankAccountController,
    required this.categoryOfWorkController,
    required this.onUserImagePicked,
    required this.socileMediaAcountController,
    required this.descriptionController,
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
          addressController: addressController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          onImagePicked: onUserImagePicked,
        ),
        BusinessInfoPage(
          pageController: pageController,
          businessNameController: businessNameController,
          bankAccountController: bankAccountController,
          socileMediaAcountController: socileMediaAcountController,
          descriptionController: descriptionController,
        ),
      ],
    );
  }
}
