import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/bindings/login_binding.dart';
import 'package:manziliapp/bindings/register_binding.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/middleware/auth_middelware.dart';
import 'package:manziliapp/view/home_view.dart';
import 'package:manziliapp/view/login_view.dart';
import 'package:manziliapp/view/profile.dart';
import 'package:manziliapp/view/register_view.dart';
import 'package:manziliapp/view/splash_view.dart';
import 'package:manziliapp/widget/home/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تسجيل UserController قبل تشغيل التطبيق
  Get.put(UserController());
  
  // يمكن تحميل البيانات المحفوظة عند بدء التطبيق إن رغبت
  await Get.find<UserController>().loadUserData();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/sp',
      getPages: [
        GetPage(
            name: '/sp',
            page: () => const SplashsView(),
            binding: LoginBinding(),
            middlewares: [AuthMiddleware()]),
        GetPage(
          name: '/login',
          page: () => const LoginView(),
            binding: LoginBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
        ),
      ],
    );
  }
}
