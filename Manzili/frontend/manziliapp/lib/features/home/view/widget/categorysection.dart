import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/shadows.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  CategorySectionState createState() => CategorySectionState();
}

class CategorySectionState extends State<CategorySection> {
  int _activeIndex = 0; // Default active card index
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
        // Now the data is a List of categories
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

    return Column(
      children: [
        const SectionHeader(title: "تصفح التصنيفات", action: "عرض الكل"),
        FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 110,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 110,
                child: Center(child: Text("حدث خطأ: ${snapshot.error}")),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: 110,
                child: const Center(child: Text("لا توجد بيانات")),
              );
            }

            final List<Category> categories = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeIndex = index;
                      });
                    },
                    child: CategoryCard(
                      title: category.name,
                      count: category.conunt.toString(),
                      imageUrl: category.imageUrl,
                      isActive: _activeIndex == index,
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Category {
  final String name;
  final String imageUrl;
  final int conunt;

  Category({
    required this.name,
    required this.imageUrl,
    required this.conunt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String rawImageUrl = json["imageUrl"] as String;
    // Prefix the domain if it starts with a slash
    if (rawImageUrl.startsWith("/")) {
      rawImageUrl = "http://man.runasp.net" + rawImageUrl;
    }
    return Category(
      name: json["name"] as String,
      imageUrl: rawImageUrl,
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
          Text(action, style: TextStyles.linkStyle),
          Text(title, style: TextStyles.sectionHeader),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.2,
      height: 98,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [Shadows.categoryShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 21.5,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: isActive ? TextStyles.linkStyle : TextStyles.sectionHeader,
          ),
          Text(
            "$count",
            style: isActive ? TextStyles.sectionHeader : TextStyles.timeStyle,
          ),
        ],
      ),
    );
  }
}
