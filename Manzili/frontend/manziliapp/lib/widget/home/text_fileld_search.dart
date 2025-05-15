import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';

class TextFileldSearch extends StatelessWidget {
  const TextFileldSearch({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      textAlign: TextAlign.right,
      controller: _searchController,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        hintText: 'ابحث هنا...',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: screenWidth * 0.04, // Responsive font size
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.03),
          child: Icon(
            Icons.search,
            color: AppColors.primaryColor,
            size: screenWidth * 0.06, // Responsive icon size
          ),
        ),
        suffixIcon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _searchController.text.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: screenWidth * 0.045, // Responsive icon size
                        color: Colors.grey.shade700,
                      ),
                    ),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                )
              : null,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.04,
          horizontal: screenWidth * 0.05,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(2),
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: screenWidth * 0.045, // Responsive font size
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
