import 'package:flutter/material.dart';

class HeaderImage extends StatelessWidget {
  const HeaderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/loginimg.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
    );
  }
}
