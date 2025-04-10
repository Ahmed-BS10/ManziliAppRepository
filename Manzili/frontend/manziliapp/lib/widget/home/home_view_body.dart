import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/view/profile.dart';
import 'package:manziliapp/widget/home/categorysection.dart';
import 'package:manziliapp/widget/home/filtersection.dart';
import 'package:manziliapp/widget/home/headersection.dart';
import 'package:manziliapp/widget/home/storelistsection.dart';
import 'package:manziliapp/widget/home/text_fileld_search.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  _HomeViewBodyState createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 3;
  final TextEditingController _searchController = TextEditingController();

  // List of pages to navigate.
  final List<Widget> _pages = [
    const ProfileScreen(),
    const NotificationPage(),
    const OrderPage(),
    const StartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white, // White background
        selectedItemColor: const Color(0xFF1548C7), // Active color
        unselectedItemColor: const Color(0xFF949494), // Inactive color
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسة',
          ),
        ],
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int? selectedCategory;
  String? selectedFilter;
  String? searchQuery; // New search query parameter
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optionally you can listen to changes if you want live search updates
    // Here we use onSubmitted for simplicity.
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      // When search is performed, clear filters and categories.
      searchQuery = query;
      selectedCategory = null;
      selectedFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(),
            CategorySection(
              activeCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                  selectedFilter = null;
                  searchQuery = null; // Clear search when using category
                  searchController.clear();
                });
              },
            ),
            FilterSection(
              activeFilter: selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  selectedFilter = filter;
                  selectedCategory = null;
                  searchQuery = null; // Clear search when using filter
                  searchController.clear();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFileldSearch(
                searchController: searchController,
                onSubmitted: _onSearchSubmitted, // pass the callback
              ),
            ),
            StoreListSection(
              category: selectedCategory,
              filter: selectedFilter,
              searchQuery: searchQuery,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على بيانات المستخدم من UserController
    final UserController userController = Get.find<UserController>();

    return Obx(() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${userController.userId.value}'),
            Text('User Token: ${userController.userToken.value}'),
            const Text('صفحة الطلبات', style: TextStyle(fontSize: 24)),
          ],
        ),
      );
    });
  }
}

/// Placeholder for Notification Page.
class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('صفحة الإشعارات',
            style: Theme.of(context).textTheme.headlineLarge));
  }
}

/// Placeholder for Profile Page.
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('صفحة الحساب',
            style: Theme.of(context).textTheme.headlineSmall));
  }
}
