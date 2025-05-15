import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/text_styles.dart';
import 'package:manziliapp/widget/home/storelistsection.dart';

class CategorySection extends StatefulWidget {
  final int? activeCategory;
  final Function(int?) onCategorySelected;

  const CategorySection({
    super.key,
    required this.onCategorySelected,
    this.activeCategory,
  });

  @override
  CategorySectionState createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  Future<List<Category>> fetchCategories() async {
    const String url = "http://man.runasp.net/api/StoreCategory/List";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      if (decoded["isSuccess"] == true && decoded["data"] != null) {
        final List<dynamic> values = decoded["data"];
        return values.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception("API returned an error: ${decoded["message"]}");
      }
    } else {
      throw Exception("Failed to fetch categories");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const SectionHeader(title: "تصفح التصنيفات", action: "عرض الكل"),
          FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 110,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  height: 110,
                  child: Center(
                      child: Text("حدث خطأ: ${snapshot.error}",
                          style: const TextStyle(color: Colors.black))),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox(
                  height: 110,
                  child: Center(
                      child: Text("لا توجد بيانات",
                          style: TextStyle(color: Colors.black))),
                );
              }

              final List<Category> categories = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: categories.map((category) {
                    final bool isActive = widget.activeCategory == category.id;
                    return GestureDetector(
                      onTap: () => widget.onCategorySelected(category.id),
                      child: CategoryCard(
                        id: category.id,
                        title: category.name,
                        count: category.conunt.toString(),
                        imageUrl: category.imageUrl,
                        isActive: isActive,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String imageUrl;
  final int conunt;

  Category({
    required this.name,
    required this.imageUrl,
    required this.conunt,
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] as int,
      name: json["name"] as String,
      imageUrl: json["imageUrl"] as String,
      conunt: json["conunt"] is int
          ? json["conunt"] as int
          : int.parse(json["conunt"].toString()),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const SectionHeader({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const StoreListSection());
            },
            child: Text(action,
                style: TextStyles.linkStyle.copyWith(color: Colors.black)),
          ),
          Text(title,
              style: TextStyles.sectionHeader.copyWith(color: Colors.black)),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final int id;
  final String title;
  final String count;
  final String imageUrl;
  final bool isActive;

  const CategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.imageUrl,
    this.isActive = false,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: screenWidth * 0.25,
      height: 110,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 50,
            height: 50,
            image: imageUrl.isNotEmpty
                ? NetworkImage('http://man.runasp.net/$imageUrl')
                : const AssetImage('lib/assets/image/burger.jpg')
                    as ImageProvider,
            semanticLabel: 'Category image for $title',
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyles.sectionHeader.copyWith(
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
          Text(
            count,
            style: TextStyles.timeStyle.copyWith(
              color: isActive ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
