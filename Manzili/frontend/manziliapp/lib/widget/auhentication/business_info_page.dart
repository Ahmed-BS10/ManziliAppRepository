import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';

class BusinessInfoPage extends StatelessWidget {
  final PageController pageController;
  final TextEditingController businessNameController;
  final TextEditingController bankAccountController;
  final TextEditingController categoryOfWorkController;

  const BusinessInfoPage({
    super.key,
    required this.pageController,
    required this.businessNameController,
    required this.bankAccountController,
    required this.categoryOfWorkController,
  });

  @override
  Widget build(BuildContext context) {
    // List of dropdown options
    final List<String> categories = [
      'Construction',
      'IT Services',
      'Retail',
      'Manufacturing',
      'Healthcare',
    ];

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
          controller: businessNameController,
          hintText: 'Business Name',
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: null, // Initial value
          decoration: InputDecoration(
            hintText: 'Category Of Work',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              categoryOfWorkController.text = newValue; // Update the controller
            }
          },
        ),
        const SizedBox(height: 10),
        CustomeTextFiled(
          controller: bankAccountController,
          hintText: 'Bank',
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
