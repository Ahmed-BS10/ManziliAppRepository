import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_indicator.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/terms_and_privacy_checbok.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool isAgreed = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeaderText(),
            if (userType == 'customer')
              BuildCustomerForm()
            else
              BuildProducerForm(),
          ],
        ),
      ),
    );
  }

  Widget BuildHeaderText() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        'يرجى إكمال جميع المعلومات\nلإنشاء حسابك على منزلي',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget BuildCustomerForm() {
    return Column(
      children: [
        PersonalInfoPage(),
        TermsAndPrivacyCheckbox(
          onChanged: (value) {
            setState(() {
              isAgreed = value;
            });
          },
        ),
        CustomTextButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && isAgreed) {
              print('Successed');
            } else {
              print('Failed');
            }
          },
          name: 'تسجيل الدخول',
          fontColor: Colors.white,
          backColor: pColor,
        ),
      ],
    );
  }

  Widget BuildProducerForm() {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: CustomPageView(pageController: _pageController),
        ),
        TermsAndPrivacyCheckbox(
          onChanged: (value) {
            setState(() {
              isAgreed = value;
            });
          },
        ),
        const SizedBox(height: 10),
        CustomIndicator(dotIndex: currentIndex),
        CustomTextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (isAgreed) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
                  ),
                );
              }
            }
          },
          name: currentIndex == 1 ? 'التسجيل' : 'التالي',
          fontColor: Colors.white,
          backColor: pColor,
        ),
      ],
    );
  }
}

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 30),
        CustomeTextFiled(hintText: 'اسمك الكامل '),
        SizedBox(height: 10),
        EmailTextFiled(),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'رقمك'),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'كلمة السر'),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'تاكيد كلمة السر'),
      ],
    );
  }
}

class BusinessInfoPage extends StatelessWidget {
  const BusinessInfoPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
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
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Business Name'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Category Of Work'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Business Address'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Short Description About Your Work'),
        SizedBox(height: 10),
        CustomeTextFiled(hintText: 'Upload Your Business Image'),
        SizedBox(height: 10),
        PasswordTextField(hintText: ' '),
        SizedBox(height: 10),
        PasswordTextField(hintText: 'تاكيد كلمة السر'),
      ],
    );
  }
}

class CustomPageView extends StatelessWidget {
  final PageController pageController;

  const CustomPageView({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const PersonalInfoPage(),
        BusinessInfoPage(pageController: pageController),
      ],
    );
  }
}
