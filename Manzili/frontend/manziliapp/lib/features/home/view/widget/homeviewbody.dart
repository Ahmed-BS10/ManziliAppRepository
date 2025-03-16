import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/features/home/view/homeview.dart';
import 'package:manziliapp/features/home/view/widget/categorysection.dart';
import 'package:manziliapp/features/home/view/widget/filtersection.dart';
import 'package:manziliapp/features/home/view/widget/headersection.dart';
import 'package:manziliapp/features/home/view/widget/storeListsection.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  _HomeViewBody createState() => _HomeViewBody();
}


class _HomeViewBody extends State<HomeViewBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    const CategorySection(),
                    const FilterSection(),
                   // const SearchBar(),
                    StoreListSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

