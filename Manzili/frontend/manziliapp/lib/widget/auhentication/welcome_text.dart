import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'مرحبا',
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}
