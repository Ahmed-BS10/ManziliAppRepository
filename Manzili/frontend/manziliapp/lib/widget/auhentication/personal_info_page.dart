import 'package:flutter/material.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/widget/auhentication/custom_password_text.dart';
import 'package:manziliapp/widget/auhentication/email_text_filed.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalInfoPage extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function(File) onImagePicked;

  const PersonalInfoPage({
    super.key,
    required this.usernameController,
    required this.phoneController,
    required this.emailController,
    required this.cityController,
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onImagePicked,
  });

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  File? image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      widget.onImagePicked(image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: image != null ? FileImage(image!) : null,
              child: image == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          CustomeTextFiled(
            controller: widget.usernameController,
            hintText: 'اسم المستخدم',
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            controller: widget.phoneController,
            hintText: 'رقمك',
          ),
          const SizedBox(height: 10),
          EmailTextFiled(
            controller: widget.emailController,
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            controller: widget.cityController,
            hintText: 'المدينة',
          ),
          const SizedBox(height: 10),
          CustomeTextFiled(
            controller: widget.addressController,
            hintText: 'عنوانك : مثل الديس - الدائرة ',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            controller: widget.passwordController,
            hintText: 'كلمة السر',
          ),
          const SizedBox(height: 10),
          PasswordTextField(
            controller: widget.confirmPasswordController,
            hintText: 'تاكيد كلمة السر',
          ),
        ],
      ),
    );
  }
}
