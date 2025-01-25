import 'package:flutter/material.dart';
import 'package:manziliapp/features/auhentication/view/login_view.dart';
import 'package:manziliapp/features/auhentication/view/register_view.dart';
import 'package:manziliapp/features/start/view/start_view.dart';

void main() {
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
