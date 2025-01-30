import 'package:flutter/material.dart';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/features/auhentication/view/login_view.dart';
import 'package:manziliapp/features/auhentication/view/register_view.dart';
import 'package:manziliapp/features/start/view/start_view.dart';

void main() async {
  AuthService authService = AuthService(apiService: ApiService());

  // var result = await authService.login('string', '777Aa@');
  // print({result.isSuccess, result.message, result.data});
  runApp(ManziliApp());
}

class ManziliApp extends StatelessWidget {
  const ManziliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        'login': (context) => LoginView(),
        'register': (context) => RegisterView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
