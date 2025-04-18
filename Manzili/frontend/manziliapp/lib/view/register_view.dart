import 'package:flutter/material.dart';
import 'package:manziliapp/widget/auhentication/register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'إعداد حسابك',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: RegisterViewBody(),
    );
  }
}
