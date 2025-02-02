import 'package:flutter/material.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/model/user_create_model.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final UserCreateModel userCreateModel = UserCreateModel(
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      phone: '',
      city: '',
      address: '',
      userName: '',
      confirmPassword: '');

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
    return Column(
      children: [
        // زر اختيار الصورة وعرضها
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
            userCreateModel.firstName = value;
          },
          hintText: 'اسمك الاول',
        ),

        const SizedBox(height: 10),
        CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.lastName = value;
            },
            hintText: 'اسمك الاخير'),

        const SizedBox(height: 10),
        CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.userName = value;
            },
            hintText: 'اسم المستخدم'),

        CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.phone = value;
            },
            hintText: 'رقمك'),
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
            hintText: 'المدينة'),
        const SizedBox(height: 10),
        CustomeTextFiled(
            onChanged: (value) {
              userCreateModel.address = value;
            },
            hintText: 'عنوانك : مثل الديس - الدائرة '),
        const SizedBox(height: 10),
        PasswordTextField(
            onChanged: (value) {
              userCreateModel.password = value;
            },
            hintText: 'كلمة السر'),
        const SizedBox(height: 10),
        PasswordTextField(
            onChanged: (value) {
              userCreateModel.confirmPassword = value;
            },
            hintText: 'تاكيد كلمة السر'),
      ],
    );
  }
}
