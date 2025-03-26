import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/model/store_create_model.dart';
import 'package:manziliapp/widget/auhentication/custom_indicator.dart';
import 'package:manziliapp/widget/auhentication/custom_page_view.dart';
import 'package:manziliapp/widget/auhentication/terms_and_privacy_checbok.dart';

class ProducerRegistrationForm extends StatefulWidget {
  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final bool isAgreed;
  final Function(bool) onAgreementChanged;
  final int currentIndex;

  const ProducerRegistrationForm({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.isAgreed,
    required this.onAgreementChanged,
    required this.currentIndex,
  });

  @override
  State<ProducerRegistrationForm> createState() =>
      _ProducerRegistrationFormState();
}

class _ProducerRegistrationFormState extends State<ProducerRegistrationForm> {
  // Controllers لحقول الصفحة الأولى (المعلومات الشخصية)
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Controllers لحقول الصفحة الثانية (معلومات العمل)
  TextEditingController businessNameController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();
  TextEditingController categoryOfWorkController = TextEditingController();
  TextEditingController businessDescriptionController = TextEditingController();

  File? userImage; // لتخزين صورة المستخدم
  File? businessImage; // لتخزين صورة العمل

  @override
  void dispose() {
    // تنظيف الـ Controllers عند إغلاق الصفحة
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    businessNameController.dispose();
    bankAccountController.dispose();
    categoryOfWorkController.dispose();
    businessDescriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // إنشاء نموذج البيانات
    StoreCreateModel storeData = StoreCreateModel(
      firstName: "as",
      lastName: "as",
      userName: usernameController.text,
      phone: phoneController.text,
      email: emailController.text,
      city: cityController.text,
      address: addressController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      businessName: businessNameController.text,
      bankAccount: "sjnasfkj",
      status: "active",
      image: userImage,
    );

    // تنفيذ عملية التسجيل هنا بدون Cubit
    print("تم تسجيل المتجر: ${storeData.userName}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: CustomPageView(
            pageController: widget.pageController,
            usernameController: usernameController,
            phoneController: phoneController,
            emailController: emailController,
            cityController: cityController,
            addressController: addressController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            businessNameController: businessNameController,
            bankAccountController: bankAccountController,
            categoryOfWorkController: categoryOfWorkController,
            onUserImagePicked: (image) {
              setState(() {
                userImage = image;
              });
            },
          ),
        ),
        TermsAndPrivacyCheckbox(
          onChanged: (value) {
            widget.onAgreementChanged(value);
          },
        ),
        const SizedBox(height: 10),
        CustomIndicator(dotIndex: widget.currentIndex),
        CustomTextButton(
          onPressed: () {
            if (widget.formKey.currentState!.validate()) {
              if (widget.isAgreed) {
                if (widget.currentIndex == 1) {
                  _submitForm();
                } else {
                  widget.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
                  ),
                );
              }
            }
          },
          name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
          fontColor: Colors.white,
          backColor: pColor,
        ),
      ],
    );
  }
}