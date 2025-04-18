import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manziliapp/core/widget/custom_text_button_icon.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomTextButtonIcon(
          title: 'Continue With Google',
          icon: Icon(
            FontAwesomeIcons.google,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 15),
        CustomTextButtonIcon(
          title: 'Continue With Apple ',
          icon: Icon(
            FontAwesomeIcons.apple,
            size: 23,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
