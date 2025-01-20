import 'package:flutter/material.dart';
import 'package:manziliapp/features/auhentication/view/login_view.dart';
import 'package:manziliapp/features/start/view/start_view.dart';

void main() {
  runApp(ManziliApp());
}

class ManziliApp extends StatelessWidget {
  const ManziliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartView(),
    );
  }
}

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
