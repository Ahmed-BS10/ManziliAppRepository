import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyCartWidget extends StatelessWidget {
  final String title;
  final String image;
  final String label;
  final void Function()? onPressed;

  const EmptyCartWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.label,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(image),
        Text(title),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ],
    );
  }
}
