import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/login_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/main.dart';
import 'package:manziliapp/model/login_model.dart';
import 'package:manziliapp/view/home_view.dart';
import 'package:manziliapp/widget/auhentication/custom_password_text.dart';
import 'package:manziliapp/widget/auhentication/email_text_filed.dart';
import 'package:manziliapp/widget/auhentication/forgot_password_text.dart';
import 'package:manziliapp/widget/auhentication/header_image.dart';
import 'package:manziliapp/widget/auhentication/register_text.dart';
import 'package:manziliapp/widget/auhentication/welcome_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}
class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginModel _loginModel = LoginModel(Email: '', Password: '');
  final LoginController loginController = Get.find<LoginController>();
  // الحصول على الـ UserController من GetX
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderImage(),
            const SizedBox(height: 15),
            const WelcomeText(),
            const SizedBox(height: 20),
            EmailTextFiled(
              onChanged: (value) {
                _loginModel.Email = value;
              },
            ),
            const SizedBox(height: 10),
            PasswordTextField(
              onChanged: (value) {
                _loginModel.Password = value;
              },
              hintText: 'كلمة السر',
            ),
            const SizedBox(height: 10),
            const ForgotPasswordText(),
            const SizedBox(height: 15),
            Obx(() {
              if (loginController.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return CustomTextButton(
                onPressed: () async {
                  await _validateForm();
                },
                name: 'تسجيل الدخول',
                radius: 23,
                fontColor: Colors.white,
                backColor: pColor,
              );
            }),
            Obx(() {
              if (loginController.successMessage.isNotEmpty) {
                return Text(
                  loginController.successMessage.value,
                  style: const TextStyle(color: Colors.green),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              if (loginController.errorMessage.isNotEmpty) {
                return Text(
                  loginController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 20),
            RegisterText(),
          ],
        ),
      ),
    );
  }

  Future<void> _validateForm() async {
    if (_formKey.currentState!.validate()) {
      await loginController.login(_loginModel);

      if (loginController.apiResponseData.isNotEmpty) {
        try {
          final id = loginController.apiResponseData['id'] as int;
          final token = loginController.apiResponseData['token'] as String;

          // حفظ البيانات باستخدام UserController
          await userController.saveUserData(id, token);

          // الانتقال إلى الصفحة الرئيسية
          Get.offAll(() => HomeView());
        } catch (e) {
          print("Error saving user data: $e");
        }
      }
    }
  }
}
