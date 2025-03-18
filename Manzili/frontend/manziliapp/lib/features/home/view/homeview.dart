import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';
import 'package:manziliapp/core/helper/shadows.dart';
import 'package:manziliapp/core/helper/text_styles.dart';
import 'package:manziliapp/features/home/view/widget/homeviewbody.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeViewBody();
  }
}




class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.searchBorder),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        textAlign: TextAlign.right, // Ensures Arabic text aligns right
        textDirection: TextDirection.rtl, // RTL support for Arabic
        decoration: InputDecoration(
          hintText: "البحث عن",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 9,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageHelper.networkImage(
              url: ImageHelper.getImageUrl("t4nkk8m1.png"),
              width: 16,
              height: 16,
            ),
          ),
        ),
      ),
    );
  }
}
