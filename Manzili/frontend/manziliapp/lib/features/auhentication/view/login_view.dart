import 'package:flutter/material.dart';
import 'package:manziliapp/features/auhentication/view/widget/login_view_body.dart';
import 'package:manziliapp/main.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginViewBody(),
    );
  }
}
