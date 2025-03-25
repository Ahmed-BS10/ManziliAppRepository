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
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.05,
        left: MediaQuery.of(context).size.width * 0.05,
        top: 30,
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          String filter = filters[index];
          bool isActive = activeFilter != null && activeFilter == filter;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterButton(
                title: filter,
                isActive: isActive,
                onTap: () {
                  onFilterSelected(filter);
                },
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
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : AppColors.filterInactive,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: isActive ? TextStyles.sectionHeader : TextStyles.timeStyle,
            ),
          ),
        ),
      ),
    );
  }
}
