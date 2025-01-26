import 'package:flutter/material.dart';
import 'package:manziliapp/features/auhentication/view/widget/business_info_page.dart';
import 'package:manziliapp/features/auhentication/view/widget/personal_info_page.dart';

class CustomPageView extends StatelessWidget {
  final PageController pageController;

  const CustomPageView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const PersonalInfoPage(),
        BusinessInfoPage(pageController: pageController),
      ],
    );
  }
}
