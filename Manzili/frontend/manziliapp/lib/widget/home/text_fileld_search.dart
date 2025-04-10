import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';

class TextFileldSearch extends StatelessWidget {
  const TextFileldSearch({
    Key? key,
    required this.searchController,
    required this.onSubmitted,
  }) : super(key: key);

  final TextEditingController searchController;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      textInputAction: TextInputAction.search,
      textAlign: TextAlign.right,
      controller: searchController,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        hintText: 'ابحث هنا...',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(
            Icons.search,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        suffixIcon: searchController.text.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8),
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
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  onPressed: () {
                    searchController.clear();
                    onSubmitted(''); // send empty search to clear search results
                  },
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
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
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      cursorColor: AppColors.primaryColor,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(2),
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
