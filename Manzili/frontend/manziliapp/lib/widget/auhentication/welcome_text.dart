import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'أهلاً بك',
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}
