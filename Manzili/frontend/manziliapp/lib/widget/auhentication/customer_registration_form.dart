import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manziliapp/controller/auth_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/model/user_create_model.dart';
import 'package:manziliapp/view/home_view.dart';
import 'package:manziliapp/widget/auhentication/custom_password_text.dart';
import 'package:manziliapp/widget/auhentication/email_text_filed.dart';
import 'package:manziliapp/widget/auhentication/terms_and_privacy_checbok.dart';

class CustomerRegistrationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isAgreed;
  final Function(bool) onAgreementChanged;

  const CustomerRegistrationForm({
    super.key,
    required this.formKey,
    required this.isAgreed,
    required this.onAgreementChanged,
  });

  @override
  _CustomerRegistrationFormState createState() =>
      _CustomerRegistrationFormState();
}

class _CustomerRegistrationFormState extends State<CustomerRegistrationForm> {
  final AuthController authController = Get.find<AuthController>();
  late UserCreateModel userCreateModel;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userCreateModel = UserCreateModel(
      image: null,
      email: "",
      address: "",
      userName: "",
      password: "",
      confirmPassword: "",
      phonenumber: "",
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userCreateModel.image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: userCreateModel.image != null
                  ? FileImage(userCreateModel.image!)
                  : null,
              child: userCreateModel.image == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          CustomeTextFiled(
            onChanged: (value) => userCreateModel.userName = value,
            hintText: 'اسم المستخدم',
          ),
          CustomeTextFiled(
            onChanged: (value) => userCreateModel.phonenumber = value,
            hintText: 'رقمك',
          ),
          const SizedBox(height: 10),
          EmailTextFiled(
            onChanged: (value) => userCreateModel.email = value,
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            onChanged: (value) => userCreateModel.address = value,
            hintText: 'عنوانك : مثل الديس - الدائرة ',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            onChanged: (value) => userCreateModel.password = value,
            hintText: 'كلمة السر',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            onChanged: (value) => userCreateModel.confirmPassword = value,
            hintText: 'تاكيد كلمة السر',
          ),
          TermsAndPrivacyCheckbox(
            onChanged: widget.onAgreementChanged,
          ),
          const SizedBox(height: 10),
          authController.isLoading.value
              ? const CircularProgressIndicator()
              : CustomTextButton(
                  onPressed: () {
                    _validateForm2();
                  },
                  name: 'تسجيل الدخول',
                  fontColor: Colors.white,
                  backColor: pColor,
                ),
          if (authController.successMessage.isNotEmpty)
            Text(
              authController.successMessage.value,
              style: const TextStyle(color: Colors.green),
            ),
          if (authController.errorMessage.isNotEmpty)
            Text(
              authController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      );
    });
  }

  Future<void> _validateForm() async {
    if (!widget.formKey.currentState!.validate()) {
      return; // Stop if form validation fails
    }

    if (!widget.isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الشروط وسياسة الخصوصية'),
        ),
      );
      return; // Stop if the user has not agreed to the terms
    }

    try {
      await authController.registerUser(userCreateModel);

      if (authController.apiResponseData.isNotEmpty) {
        try {
          final id = authController.apiResponseData['id'] as int;
          final token = authController.apiResponseData['token'] as String;

          await userController.saveUserData(id, token);

          // Navigate to HomeView
          Get.offAll(() => const HomeView());
        } catch (e) {
          print("Error saving user data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error saving user data: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء التسجيل. حاول مرة أخرى.'),
          ),
        );
      }
    } catch (e) {
      print("Error during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ غير متوقع. حاول مرة أخرى لاحقًا.'),
        ),
      );
    }
  }

  Future<void> _validateForm2() async {
    if (widget.formKey.currentState!.validate()) {
      await authController.registerUser(userCreateModel);

      try {
        final id = authController.apiResponseData['id'] as int;
        final token = authController.apiResponseData['token'] as String;
        await userController.saveUserData(id, token);
        Get.offAll(() => HomeView());
      } catch (e) {
        print("Error saving user data: $e");
      }
    }
  }
}
