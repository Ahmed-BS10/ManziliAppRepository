import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

class FilterSection extends StatefulWidget {
  final Function(String) onFilterSelected;

  const FilterSection({super.key, required this.onFilterSelected});

  @override
  FilterSectionState createState() => FilterSectionState();
}

class FilterSectionState extends State<FilterSection> {
  int _activeIndex = 3; // Default active button index (3 - "الكل")
  final List<String> filters = ["المفضلة", "الجديدة", "الأقرب", "الكل"];
  final List<String> endpoints = [
    "https://localhost:7175/api/Store/GetUserFavoriteStores?userId=1",
    "https://localhost:7175/api/Store/OrderByDescending",
    "http://man.runasp.net/api/Store/Nearby", // Assuming a nearby endpoint
    "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0"
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 30),
      child: Row(
        children: List.generate(filters.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeIndex = index;
                });
                widget.onFilterSelected(endpoints[index]);
              },
              child: FilterButton(
                title: filters[index],
                isActive: _activeIndex == index,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool isActive;

  const FilterButton({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.filterInactive,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: isActive ? TextStyles.sectionHeader : TextStyles.timeStyle,
      ),
    );
  }
}