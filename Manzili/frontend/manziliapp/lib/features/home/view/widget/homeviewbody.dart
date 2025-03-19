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
  int? selectedCategory; // التصنيف المختار
  String? selectedEndpoint; // Endpoint for the selected filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              CategorySection(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              FilterSection(
                onFilterSelected: (endpoint) {
                  setState(() {
                    selectedEndpoint = endpoint;
                  });
                },
              ),
              StoreListSection(
                category: selectedCategory,
                endpoint: selectedEndpoint, // Pass the endpoint to StoreListSection
              ),
            ],
          ),
        ),
      ),
    );
  }
}