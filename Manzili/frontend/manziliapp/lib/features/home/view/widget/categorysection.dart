
import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';
import 'package:manziliapp/core/helper/shadows.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  CategorySectionState createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  int _activeIndex = 2; // Default active card (index 2 - "سبالم")

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SectionHeader(title: "تصفح التصنيفات", action: "عرض الكل"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeIndex = index;
                  });
                },
                child: CategoryCard(
                  title: _getTitle(index),
                  count: _getCount(index),
                  imageUrl: _getImageUrl(index),
                  isActive: _activeIndex == index,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "مؤكلات";
      case 1:
        return "تالكأ";
      case 2:
        return "سبالم";
      case 3:
        return "تالكأ";
      default:
        return "";
    }
  }

  String _getCount(int index) {
    switch (index) {
      case 0:
        return "20";
      case 1:
        return "31";
      case 2:
        return "21";
      case 3:
        return "31";
      default:
        return "";
    }
  }

  String _getImageUrl(int index) {
    switch (index) {
      case 0:
        return "ebscxfd0.png";
      case 1:
        return "ovy2eeyp.png";
      case 2:
        return "kfwocaaa.png";
      case 3:
        return "u5wdh39c.png";
      default:
        return "";
    }
  }
}




class SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const SectionHeader({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(action, style: TextStyles.linkStyle),
          Text(title, style: TextStyles.sectionHeader),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final String imageUrl;
  final bool isActive;

  const CategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.imageUrl,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.2,
      height: 98,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [Shadows.categoryShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 21.5,
            backgroundImage: NetworkImage(ImageHelper.getImageUrl(imageUrl)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: isActive ? TextStyles.linkStyle : TextStyles.sectionHeader,
          ),
          Text(
            "$count",
            style: isActive ? TextStyles.sectionHeader : TextStyles.timeStyle,
          ),
        ],
      ),
    );
  }
}
