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
    final List<String> filters = ["المفضلة", "الجديدة", "الكل"];
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((filter) {
          final bool isActive = activeFilter != null && activeFilter == filter;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterButton(
                title: filter,
                isActive: isActive,
                onTap: () => onFilterSelected(filter),
              ),
            ),
          );
        }).toList(),
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
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: isActive
                  ? TextStyles.sectionHeader.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : TextStyles.timeStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
