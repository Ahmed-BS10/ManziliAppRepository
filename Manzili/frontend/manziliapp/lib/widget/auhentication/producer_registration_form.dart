import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/auth_controller.dart';
import 'package:manziliapp/model/store_create_model.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController socileMediaAcountController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
    final TextEditingController bookTime = TextEditingController();


  File? userImage;
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bankAccountController.dispose();
    businessDescriptionController.dispose();
    socileMediaAcountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final storeData = StoreCreateModel(
      userName: usernameController.text,
      phonenumber: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      bankAccount: bankAccountController.text,
      description: descriptionController.text,
      image: userImage,
      socileMediaAcount: socileMediaAcountController.text,
    );

    authController.registerStore(storeData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: CustomPageView(
            bookTime: bookTime,
            pageController: widget.pageController,
            usernameController: usernameController,
            phoneController: phoneController,
            emailController: emailController,
            addressController: addressController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            bankAccountController: bankAccountController,
            categoryOfWorkController: businessDescriptionController,
            onUserImagePicked: (image) => setState(() => userImage = image),
            socileMediaAcountController: socileMediaAcountController,
            descriptionController: descriptionController,
          ),
        ),
        TermsAndPrivacyCheckbox(
          onChanged: widget.onAgreementChanged,
        ),
        const SizedBox(height: 10),
        CustomIndicator(dotIndex: widget.currentIndex),
        Obx(() {
          if (authController.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return CustomTextButton(
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
                      content: Text(
                          'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
                    ),
                  );
                }
              }
            },
            name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
            fontColor: Colors.white,
            backColor: pColor,
          );
        }),
      ],
    );
  }
}
