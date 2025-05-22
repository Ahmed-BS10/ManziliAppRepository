import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool showMore;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.showMore = false,
  });

  @override
  Widget build(BuildContext context) {
    // Remove all occurrences of "الكل" and add it only once at the start
    final filteredCategories = categories.where((c) => c != 'الكل').toList();
    final displayCategories = ['الكل', ...filteredCategories];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 16, right: 16), // Add left margin here
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: displayCategories.length + (showMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Show more button
            if (showMore && index == displayCategories.length) {
              return GestureDetector(
                onTap: () {
                  // Handle show more action
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1548C7)),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1548C7),
                    ),
                  ),
                ),
              );
            }

            final category = displayCategories[index];
            final isSelected = category == selectedCategory;

            return GestureDetector(
              onTap: () {
                onCategorySelected(category);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1548C7) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF1548C7),
                    width: isSelected ? 0 : 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1548C7),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
