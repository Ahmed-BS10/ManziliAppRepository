import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/bindings/login_binding.dart';
import 'package:manziliapp/bindings/register_binding.dart';
import 'package:manziliapp/view/register_view.dart';
import 'package:manziliapp/view/splash_view.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:manziliapp/widget/home/favorite_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ],
    child: const MyApp2(),
  ));
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashsView(),
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

// MultiProvider(
//   providers: [
//     ChangeNotifierProvider(create: (_) => FavoriteProvider()),
//     // Add other providers here if needed
//   ],
//   child:

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(

//       home: HomeView(),
//     );
//   }
// }

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
