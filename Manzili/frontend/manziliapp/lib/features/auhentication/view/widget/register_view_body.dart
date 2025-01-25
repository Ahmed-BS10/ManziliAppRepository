import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/core/widget/custome_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_indicator.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_password_text.dart';
import 'package:manziliapp/features/auhentication/view/widget/email_text_filed.dart';
import 'package:manziliapp/features/auhentication/view/widget/login_view_body.dart';
import 'package:manziliapp/features/auhentication/view/widget/terms_and_privacy_checbok.dart';
import 'package:manziliapp/features/start/view/start_view.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Directionality(
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
              ),
              const SizedBox(height: 20),
              if (userType == 'customer') ...[
                const SizedBox(height: 70),
                const CustomeTextFiled(hintText: 'اسمك الكامل '),
                const SizedBox(height: 10),
                const EmailTextFiled(),
                const SizedBox(height: 10),
                const CustomeTextFiled(hintText: 'رقمك'),
                const SizedBox(height: 10),
                const PasswordTextField(hintText: 'كلمة السر'),
                const SizedBox(height: 10),
                const PasswordTextField(hintText: 'تاكيد كلمة السر'),
                const TermsAndPrivacyCheckbox(),
                CustomTextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Successed');
                    } else {
                      print('Failed');
                    }
                  },
                  name: 'تسجيل الدخول',
                  fontColor: Colors.white,
                  backColor: pColor,
                ),
              ] else if (userType == 'producer') ...[
                SizedBox(
                  height: 400,
                  child: CustomPageView(
                    pageController: _pageController,
                    currentIndex: currentIndex,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    onPageChanged2: (index) {
                      // تحديد ما إذا كان التمرير مسموحًا
                      if (index == 1 && _formKey.currentState!.validate()) {
                        return 1; // السماح بالتمرير
                      } else if (index >= 1) {
                        return 1; // السماح بالتمرير
                      }
                      return 0; // منع التمرير
                    },
                  ),
                ),
                const TermsAndPrivacyCheckbox(),
                const SizedBox(height: 10),
                CustomIndicator(dotIndex: currentIndex),
                CustomTextButton(
                  onPressed: () {
                    if (currentIndex < 1 && _formKey.currentState!.validate()) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  name: currentIndex == 1 ? 'التسجيل' : 'التالي',
                  fontColor: Colors.white,
                  backColor: pColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// class RegisterViewBody extends StatefulWidget {
//   const RegisterViewBody({super.key});

//   @override
//   State<RegisterViewBody> createState() => _RegisterViewBodyState();
// }

// class _RegisterViewBodyState extends State<RegisterViewBody> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final PageController _pageController = PageController(initialPage: 0);
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Text(
//                   'يرجى إكمال جميع المعلومات\nلإنشاء حسابك على منزلي',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (userType == 'customer') ...[
//                 const SizedBox(height: 70),
//                 const CustomeTextFiled(hintText: 'اسمك الكامل '),
//                 const SizedBox(height: 10),
//                 const EmailTextFiled(),
//                 const SizedBox(height: 10),
//                 const CustomeTextFiled(hintText: 'رقمك'),
//                 const SizedBox(height: 10),
//                 const PasswordTextField(hintText: 'كلمة السر'),
//                 const SizedBox(height: 10),
//                 const PasswordTextField(hintText: 'تاكيد كلمة السر'),
//                 const TermsAndPrivacyCheckbox(),
//                 CustomTextButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       print('Successed');
//                     } else {
//                       print('Failed');
//                     }
//                   },
//                   name: 'تسجيل الدخول',
//                   fontColor: Colors.white,
//                   backColor: pColor,
//                 ),
//               ] else if (userType == 'producer') ...[
//                 SizedBox(
//                   height: 400,
//                   child: CustomPageView(
//                     onPageChanged2: (p0) {
//                       if (currentIndex == 1 &&
//                           _formKey.currentState!.validate()) {
//                         return true;
//                       } else if (currentIndex > 1) {
//                         return true;
//                       }

//                       return false;
//                     },
//                     pageController: _pageController,
//                     currentIndex: currentIndex,
//                     onPageChanged: (index) {
//                       setState(() {
//                         currentIndex = index;
//                       });
//                     },
//                   ),
//                 ),
//                 const TermsAndPrivacyCheckbox(),
//                 const SizedBox(height: 10),
//                 CustomIndicator(dotIndex: currentIndex),
//                 CustomTextButton(
//                   onPressed: () {
//                     if (currentIndex < 1 && _formKey.currentState!.validate()) {
//                       isFormValid = true;
//                       _pageController.nextPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       );

//                       setState(() {
//                         isFormValid = true;
//                       });
//                     }

//                     print(isFormValid);
//                   },
//                   name: currentIndex == 1 ? 'التسجيل' : 'التالي',
//                   fontColor: Colors.white,
//                   backColor: pColor,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PageViewItem extends StatelessWidget {
//   const PageViewItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const [
//         SizedBox(height: 70),
//         CustomeTextFiled(hintText: 'اسمك الكامل '),
//         SizedBox(height: 10),
//         EmailTextFiled(),
//         SizedBox(height: 10),
//         CustomeTextFiled(hintText: 'رقمك'),
//         SizedBox(height: 10),
//         PasswordTextField(hintText: 'كلمة السر'),
//         SizedBox(height: 10),
//         PasswordTextField(hintText: 'تاكيد كلمة السر'),
//       ],
//     );
//   }
// }

// class CustomPageView extends StatelessWidget {
//   final PageController pageController;
//   final int currentIndex;
//   final Function(int) onPageChanged;
//   final Function(bool) onPageChanged2;

//   const CustomPageView({
//     Key? key,
//     required this.pageController,
//     required this.currentIndex,
//     required this.onPageChanged,
//     required this.onPageChanged2,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 400, // Set a height for the PageView
//       child: PageView(
//         physics: onPageChanged2 == true
//             ? ScrollPhysics()
//             : NeverScrollableScrollPhysics(),
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         children: const [
//           PageViewItem(),
//           WelcomeText(),
//         ],
//       ),
//     );
//   }
// }

class CustomPageView extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;
  final Function(int) onPageChanged2; // تغيير النوع إلى Function(int)

  const CustomPageView({
    Key? key,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onPageChanged2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: PageView(
        physics: onPageChanged2(currentIndex) == 1 // استدعاء الدالة مع currentIndex
            ? const PageScrollPhysics() // السماح بالتمرير
            : const NeverScrollableScrollPhysics(), // منع التمرير
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          WelcomeText(),
          WelcomeText(),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 70),
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
