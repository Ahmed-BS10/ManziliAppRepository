import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

class FilterSection extends StatelessWidget {
  final String? activeFilter;
  final Function(String) onFilterSelected;

  const FilterSection({
    super.key,
    required this.onFilterSelected,
    this.activeFilter,
  });

  @override
  Widget build(BuildContext context) {
    // Only three filters remain, as "الأقرب" has been removed.
    final List<String> filters = ["المفضلة", "الجديدة", "الكل"];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 30,
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          String filter = filters[index];
          bool isActive = activeFilter != null && activeFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onFilterSelected(filter);
              },
              child: FilterButton(
                title: filter,
                isActive: isActive,
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

  const FilterButton({
    super.key,
    required this.title,
    this.isActive = false,
  });

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
