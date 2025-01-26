import 'package:flutter/material.dart';
import 'package:manziliapp/features/forgot_password/view/widget/forgot_password_view_body.dart';
import 'package:manziliapp/main.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPasswordViewBody(),
    );
  }
}
