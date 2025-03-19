import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/features/home/view/widget/categorysection.dart';
import 'package:manziliapp/features/home/view/widget/filtersection.dart';
import 'package:manziliapp/features/home/view/widget/headersection.dart';
import 'package:manziliapp/features/home/view/widget/storeListsection.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  _HomeViewBodyState createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int? selectedCategory;
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderSection(),
              CategorySection(
                activeCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    // When a category is selected, clear the filter selection.
                    selectedCategory = category;
                    selectedFilter = null;
                  });
                },
              ),
              FilterSection(
                activeFilter: selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    // When a filter is selected, clear the category selection.
                    selectedFilter = filter;
                    selectedCategory = null;
                  });
                },
              ),
              StoreListSection(
                category: selectedCategory,
                filter: selectedFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
