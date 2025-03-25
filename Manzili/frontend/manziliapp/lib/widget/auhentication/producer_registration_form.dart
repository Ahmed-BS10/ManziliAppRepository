// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:manziliapp/core/constant/constant.dart';
// import 'package:manziliapp/core/widget/custom_text_bottun.dart';
// import 'package:manziliapp/controller/cubit/register_store_cubit.dart';
// import 'package:manziliapp/model/store_create_model.dart';
// import 'package:manziliapp/model/user_create_model.dart';
// import 'package:manziliapp/widget/auhentication/custom_indicator.dart';
// import 'package:manziliapp/widget/auhentication/custom_page_view.dart';
// import 'package:manziliapp/widget/auhentication/terms_and_privacy_checbok.dart';

// // class ProducerRegistrationForm extends StatefulWidget {
// //   final PageController pageController;
// //   final GlobalKey<FormState> formKey;
// //   final bool isAgreed;
// //   final Function(bool) onAgreementChanged;
// //   final int currentIndex;

// //   const ProducerRegistrationForm({
// //     super.key,
// //     required this.pageController,
// //     required this.formKey,
// //     required this.isAgreed,
// //     required this.onAgreementChanged,
// //     required this.currentIndex,
// //   });

// //   @override
// //   State<ProducerRegistrationForm> createState() =>
// //       _ProducerRegistrationFormState();
// // }

// // class _ProducerRegistrationFormState extends State<ProducerRegistrationForm> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         SizedBox(
// //           height: 500,
// //           child: CustomPageView(pageController: widget.pageController),
// //         ),
// //         TermsAndPrivacyCheckbox(
// //           onChanged: (value) {
// //             widget.onAgreementChanged(value);
// //           },
// //         ),
// //         const SizedBox(height: 10),
// //         CustomIndicator(dotIndex: widget.currentIndex),
// //         CustomTextButton(
// //           onPressed: () {
// //             if (widget.formKey.currentState!.validate()) {
// //               if (widget.isAgreed) {
// //                 widget.pageController.nextPage(
// //                   duration: const Duration(milliseconds: 300),
// //                   curve: Curves.easeInOut,
// //                 );
// //               } else {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(
// //                     content: Text(
// //                         'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
// //                   ),
// //                 );
// //               }
// //             }
// //           },
// //           name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
// //           fontColor: Colors.white,
// //           backColor: pColor,
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class ProducerRegistrationForm extends StatefulWidget {
// //   final PageController pageController;
// //   final GlobalKey<FormState> formKey;
// //   final bool isAgreed;
// //   final Function(bool) onAgreementChanged;
// //   final int currentIndex;

// //   const ProducerRegistrationForm({
// //     super.key,
// //     required this.pageController,
// //     required this.formKey,
// //     required this.isAgreed,
// //     required this.onAgreementChanged,
// //     required this.currentIndex,
// //   });

// //   @override
// //   State<ProducerRegistrationForm> createState() =>
// //       _ProducerRegistrationFormState();
// // }

// // class _ProducerRegistrationFormState extends State<ProducerRegistrationForm> {
// //   late RegisterStoreCubit registerStoreCubit;

// //   @override
// //   void initState() {
// //     super.initState();
// //     registerStoreCubit = RegisterStoreCubit();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => registerStoreCubit,
// //       child: BlocListener<RegisterStoreCubit, RegisterStoreState>(
// //         listener: (context, state) {
// //           if (state is RegisterStoreStateSuccess) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               SnackBar(content: Text(state.message), backgroundColor: Colors.green),
// //             );
// //           } else if (state is RegisterStoreStateFailure) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
// //             );
// //           }
// //         },
// //         child: Column(
// //           children: [
// //             SizedBox(
// //               height: 500,
// //               child: CustomPageView(pageController: widget.pageController),
// //             ),
// //             TermsAndPrivacyCheckbox(
// //               onChanged: (value) {
// //                 widget.onAgreementChanged(value);
// //               },
// //             ),
// //             const SizedBox(height: 10),
// //             CustomIndicator(dotIndex: widget.currentIndex),
// //             BlocBuilder<RegisterStoreCubit, RegisterStoreState>(
// //               builder: (context, state) {
// //                 return CustomTextButton(
// //                   onPressed: () {
// //                     if (widget.formKey.currentState!.validate()) {
// //                       if (widget.isAgreed) {
// //                         if (widget.currentIndex == 1) {
// //                           _submitForm();
// //                         } else {
// //                           widget.pageController.nextPage(
// //                             duration: const Duration(milliseconds: 300),
// //                             curve: Curves.easeInOut,
// //                           );
// //                         }
// //                       } else {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                             content: Text('يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
// //                           ),
// //                         );
// //                       }
// //                     }
// //                   },
// //                   name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
// //                   fontColor: Colors.white,
// //                   backColor: pColor,
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _submitForm() {
// //     final store = StoreCreateModel(
// //       userName: "اسم المستخدم",  // استبدل بقيمة الإدخال الفعلي
// //       phone: "رقم الهاتف",
// //       email: "البريد الإلكتروني",
// //       city: "المدينة",
// //       address: "العنوان",
// //       bankAccount: "الحساب البنكي",
// //       status: "الحالة",
// //       businessName: "اسم المتجر",
// //       password: "كلمة المرور",
// //       confirmPassword: "تاكيد كلمة المرور",
// //     );

// //     registerStoreCubit.register(store);
// //   }
// // }

// class ProducerRegistrationForm extends StatefulWidget {
//   final PageController pageController;
//   final GlobalKey<FormState> formKey;
//   final bool isAgreed;
//   final Function(bool) onAgreementChanged;
//   final int currentIndex;

//   const ProducerRegistrationForm({
//     super.key,
//     required this.pageController,
//     required this.formKey,
//     required this.isAgreed,
//     required this.onAgreementChanged,
//     required this.currentIndex,
//   });

//   @override
//   State<ProducerRegistrationForm> createState() =>
//       _ProducerRegistrationFormState();
// }

// class _ProducerRegistrationFormState extends State<ProducerRegistrationForm> {
//   late RegisterStoreCubit registerStoreCubit;

//   // Controllers لحقول الصفحة الأولى (المعلومات الشخصية)
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   // Controllers لحقول الصفحة الثانية (معلومات العمل)
//   TextEditingController businessNameController = TextEditingController();
//   TextEditingController bankAccountController = TextEditingController();
//   TextEditingController categoryOfWorkController = TextEditingController();
//   TextEditingController businessDescriptionController = TextEditingController();

//   File? userImage; // لتخزين صورة المستخدم
//   File? businessImage; // لتخزين صورة العمل

//   @override
//   void initState() {
//     super.initState();
//     registerStoreCubit = RegisterStoreCubit();
//   }

//   @override
//   void dispose() {
//     // تنظيف الـ Controllers عند إغلاق الصفحة
//     usernameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     cityController.dispose();
//     addressController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     businessNameController.dispose();
//     bankAccountController.dispose();
//     categoryOfWorkController.dispose();
//     businessDescriptionController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     // إنشاء نموذج البيانات
//     StoreCreateModel storeData = StoreCreateModel(
//       firstName: "as",
//       lastName: "as",
//       userName: usernameController.text,
//       phone: phoneController.text,
//       email: emailController.text,
//       city: cityController.text,
//       address: addressController.text,
//       password: passwordController.text,
//       confirmPassword: confirmPasswordController.text,
//       businessName: businessNameController.text,
//       //bankAccount: bankAccountController.text,
//       status: "active", // يمكن تغييرها حسب

//       // userName: "asaas",
//       // phone: "525245255",
//       // businessName: "45454",
//       bankAccount: "sjnasfkj",
//       //   status: "active",

//       image: userImage,
//     );

//     final storeData2 = StoreCreateModel(
//       firstName: "as",
//       lastName: "as",
//       userName: "nnnnn2",
//       phone: "5252255",
//       email: "nmnmnmn2",
//       city: "nasjfk",
//       address: "snc",
//       password: "777Aa@",
//       confirmPassword: "777Aa@",
//       businessName: "45454",
//       bankAccount: "sjnasfkj",
//       status: "active", // يمكن تغييرها حسب الحاجة
//       image: userImage,
//     );

//     // UserCreateModel newUser = UserCreateModel(
//     //   firstName: "",
//     //   lastName: "Ahmed",
//     //   email: "ali.com",
//     //   phone: "+934567",
//     //   city: "المكلا",
//     //   address: "الديس - الدائرة",
//     //   userName: "8789789",
//     //   password: "777Aa@",
//     //   confirmPassword: "777Aa@",
//     // );

//     // استدعاء الـ Cubit لتسجيل المتجر
//     registerStoreCubit.register(storeData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => registerStoreCubit,
//       child: BlocListener<RegisterStoreCubit, RegisterStoreState>(
//         listener: (context, state) {
//           if (state is RegisterStoreStateSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else if (state is RegisterStoreStateFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: Column(
//           children: [
//             SizedBox(
//               height: 500,
//               child: CustomPageView(
//                 pageController: widget.pageController,
//                 usernameController: usernameController,
//                 phoneController: phoneController,
//                 emailController: emailController,
//                 cityController: cityController,
//                 addressController: addressController,
//                 passwordController: passwordController,
//                 confirmPasswordController: confirmPasswordController,
//                 businessNameController: businessNameController,
//                 bankAccountController: bankAccountController,
//                 categoryOfWorkController: categoryOfWorkController,
//                 onUserImagePicked: (image) {
//                   setState(() {
//                     userImage = image;
//                   });
//                 },
//               ),
//             ),
//             TermsAndPrivacyCheckbox(
//               onChanged: (value) {
//                 widget.onAgreementChanged(value);
//               },
//             ),
//             const SizedBox(height: 10),
//             CustomIndicator(dotIndex: widget.currentIndex),
//             BlocBuilder<RegisterStoreCubit, RegisterStoreState>(
//               builder: (context, state) {
//                 return CustomTextButton(
//                   onPressed: () {
//                     if (widget.formKey.currentState!.validate()) {
//                       if (widget.isAgreed) {
//                         if (widget.currentIndex == 1) {
//                           _submitForm();
//                         } else {
//                           widget.pageController.nextPage(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text(
//                                 'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
//                   fontColor: Colors.white,
//                   backColor: pColor,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
