import 'package:flutter/material.dart';
import 'package:manziliapp/widget/forgot%20password/forgot_password_view_body.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ForgotPasswordViewBody(),
    );
  }
}
