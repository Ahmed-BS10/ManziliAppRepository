import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/controller/category_controller.dart';

class BusinessInfoPage extends StatelessWidget {
  final PageController pageController;
  final TextEditingController bankAccountController;
  final TextEditingController socileMediaAcountController;
  final TextEditingController descriptionController;
  final TextEditingController bookTime;


  const BusinessInfoPage({
    super.key,
    required this.pageController,
    required this.bankAccountController,
    required this.socileMediaAcountController,
    required this.descriptionController, 
    required this.bookTime,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());

    // Fetch categories when the widget is built
    categoryController.fetchCategories();

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: pColor,
            ),
          ),
        ),
       
        const SizedBox(height: 10),
        CustomeTextFiled(
          controller: descriptionController,
          hintText: 'الوصف',
        ),
        const SizedBox(height: 10),
        CustomeTextFiled(
          controller: bankAccountController,
          hintText: 'حسابك',
        ),
        const SizedBox(height: 10),
        CustomeTextFiled(
          controller: socileMediaAcountController,
          hintText: 'تواصل الاجتماعي',
        ),
        const SizedBox(height: 10),
        CustomeTextFiled(
          controller: socileMediaAcountController,
          hintText: 'وقت تسليم',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 51,
          width: 298,
          child: Obx(() {
            if (categoryController.isLoading.value) {
              return const CircularProgressIndicator();
            }
            return DropdownButtonFormField<String>(
              value: null, // Initial value
              decoration: InputDecoration(
                hintText: 'تصنيف العمل',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: categoryController.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['name'], // Use category name as the value
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  categoryController.toggleCategorySelection(newValue);
                }
              },
            );
          }),
        ),
        const SizedBox(height: 10),
        Obx(() {
          return Wrap(
            children: categoryController.selectedCategoryNames.map((name) {
              return Chip(
                label: Text(name), // Display the category name
                onDeleted: () {
                  categoryController.toggleCategorySelection(name);
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
