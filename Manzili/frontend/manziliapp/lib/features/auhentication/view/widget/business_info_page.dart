import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';

// class BusinessInfoPage extends StatelessWidget {
//   const BusinessInfoPage({super.key, required this.pageController});

//   final PageController pageController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Align(
//             alignment: Alignment.topLeft,
//             child: IconButton(
//               onPressed: () {
//                 pageController.previousPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios_rounded,
//                 color: pColor,
//               ),
//             )),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'Business Name'),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'Category Of Work'),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'Business Address'),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'Short Description About Your Work'),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'Upload Your Business Image'),
//         SizedBox(height: 10),
//         PasswordTextField(hintText: ' '),
//         SizedBox(height: 10),
//         PasswordTextField(hintText: 'تاكيد كلمة السر'),
//       ],
//     );
//   }
// }

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
        CustomeTextFiled(
          controller: categoryOfWorkController,
          hintText: 'Category Of Work',
        ),

        const SizedBox(height: 10),

        CustomeTextFiled(
          controller: bankAccountController,
          hintText: 'bank',
        ),
        const SizedBox(height: 10),
        // GestureDetector(
        //   onTap: () async {
        //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        //     if (pickedFile != null) {
        //       onImagePicked(File(pickedFile.path));
        //     }
        //   },
        //   child: CustomeTextFiled(
        //     hintText: 'Upload Your Business Image',

        //   ),
        // ),
      ],
    );
  }
}
