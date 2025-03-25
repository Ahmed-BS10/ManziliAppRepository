import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manziliapp/controller/register-controller.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/model/user_create_model.dart';
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
  final RegisterController registerController = Get.find<RegisterController>();

  late UserCreateModel userCreateModel;

  @override
  void initState() {
    super.initState();
    // Initialize userCreateModel with default values
    userCreateModel = UserCreateModel(
      image: null,
      email: "",
      city: "",
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
            onChanged: (value) {
              userCreateModel.userName = value;
            },
            hintText: 'اسم المستخدم',
          ),
          CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.phonenumber = value;
            },
            hintText: 'رقمك',
          ),
          const SizedBox(height: 10),
          EmailTextFiled(
            onChanged: (value) {
              userCreateModel.email = value;
            },
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.city = value;
            },
            hintText: 'المدينة',
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.address = value;
            },
            hintText: 'عنوانك : مثل الديس - الدائرة ',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            onChanged: (value) {
              userCreateModel.password = value;
            },
            hintText: 'كلمة السر',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            onChanged: (value) {
              userCreateModel.confirmPassword = value;
            },
            hintText: 'تاكيد كلمة السر',
          ),
          TermsAndPrivacyCheckbox(
            onChanged: (value) {
              widget.onAgreementChanged(value);
            },
          ),
          const SizedBox(height: 10),
          registerController.isLoading.value
              ? const CircularProgressIndicator()
              : CustomTextButton(
                  onPressed: () {
                    if (widget.formKey.currentState!.validate()) {
                      if (widget.isAgreed) {
                        registerController.registerUser(userCreateModel);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('يجب الموافقة على الشروط وسياسة الخصوصية'),
                          ),
                        );
                      }
                    }
                  },
                  name: 'تسجيل الدخول',
                  fontColor: Colors.white,
                  backColor: pColor,
                ),
          if (registerController.successMessage.isNotEmpty)
            Text(
              registerController.successMessage.value,
              style: const TextStyle(color: Colors.green),
            ),
          if (registerController.errorMessage.isNotEmpty)
            Text(
              registerController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      );
    });
  }
}