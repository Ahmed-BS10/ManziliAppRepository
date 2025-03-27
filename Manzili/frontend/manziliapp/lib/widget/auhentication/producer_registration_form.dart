import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/store_controller.dart';
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
  // Controllers for form fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();
  TextEditingController businessDescriptionController = TextEditingController();

  File? userImage; // User image

  final StoreController storeController = Get.put(StoreController());

  @override
  void dispose() {
    // Dispose controllers
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    businessNameController.dispose();
    bankAccountController.dispose();
    businessDescriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Create store data model
    StoreCreateModel storeData = StoreCreateModel(
      userName: usernameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      businessName: businessNameController.text,
      bankAccount: bankAccountController.text,
      description: businessDescriptionController.text,
      image: userImage,
      socileMediaAcount: '',
    );

    // Call the registerStore method
    storeController.registerStore(storeData);
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
            categoryOfWorkController: businessDescriptionController,
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
        Obx(() {
          if (storeController.isLoading.value) {
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