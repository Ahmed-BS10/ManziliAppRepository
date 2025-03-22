import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/features/home/view/widget/categorysection.dart';
import 'package:manziliapp/features/home/view/widget/filtersection.dart';
import 'package:manziliapp/features/home/view/widget/headersection.dart';
import 'package:manziliapp/features/home/view/widget/storeListsection.dart';
import 'package:manziliapp/features/home/view/widget/text_fileld_search.dart';

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
    const ProfilePage(),
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
        items: const [
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

/// HomePage contains your original UI elements.
class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int? selectedCategory;
  String? selectedFilter;

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
                });
              },
            ),
            FilterSection(
              activeFilter: selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  selectedFilter = filter;
                  selectedCategory = null;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFileldSearch(searchController: SearchController()),
            ),
            StoreListSection(
              category: selectedCategory,
              filter: selectedFilter,
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for Order Page.
class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('صفحة الطلبات',
            style: Theme.of(context).textTheme.headlineSmall));
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
