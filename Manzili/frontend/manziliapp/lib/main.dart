import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/bindings/login_binding.dart';
import 'package:manziliapp/bindings/register_binding.dart';
import 'package:manziliapp/view/register_view.dart';
import 'package:manziliapp/view/start_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const StartView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
      ],
    );
  }
}