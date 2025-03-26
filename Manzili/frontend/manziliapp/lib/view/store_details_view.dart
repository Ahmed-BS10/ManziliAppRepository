import 'package:flutter/material.dart';
import 'package:manziliapp/widget/store/store_about.dart';
import 'package:manziliapp/widget/store/store_contact.dart';
import 'package:manziliapp/widget/store/store_header.dart';
import 'package:manziliapp/widget/store/store_tabs.dart';

import 'products_view.dart';
import 'reviews_view.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  int _selectedTabIndex = 0; // Default to about tab (عن المتجر)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, logo, and cart
            const StoreHeader(),

            // Store info (favorite, rating, name) and category display
            const StoreInfoSection(),

            // Navigation tabs
            StoreTabs(
              selectedTabIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),

            // Main content based on selected tab
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // About store (عن المتجر)
        return SingleChildScrollView(
          child: Column(
            children: const [
              StoreAbout(),
              StoreContact(),
            ],
          ),
        );
      case 1: // Reviews (تقييمات المتجر)
        return const ReviewsView();
      case 2: // Store policy (سياسة المتجر)
        return const Center(
          child: Text('محتوى قيد التطوير'),
        );
      case 3: // Products (منتجاتنا)
        return const ProductsView();
      default:
        return const Center(
          child: Text('محتوى قيد التطوير'),
        );
    }
  }
}

class StoreInfoSection extends StatelessWidget {
  const StoreInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Store info (favorite, rating, name)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Favorite button
              IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: Color(0xFF1548C7), size: 35),
                onPressed: () {},
              ),

              // Rating
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 28),
                  SizedBox(width: 4),
                  Text('4.6',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                ],
              ),

              const SizedBox(width: 16),

              // Store name with icon before text and left offset
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(-45, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'متجر الأسر المنتجة',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.store,
                            color: Color(0xFF1548C7),
                            size: 31), // الأيقونة أولاً
                        SizedBox(width: 6), // مسافة صغيرة بين الأيقونة والنص
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Categories display (non-clickable)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // زر مقاطعات الأيسر
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECF1F6), // اللون الأزرق الداكن
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'مأكولات',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66707A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECF1F6), // اللون الأخضر
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'حرف يدوية',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66707A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // زر مقاطعات الأيمن
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECF1F6), // اللون البرتقالي
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  'مأكولات',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF66707A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
