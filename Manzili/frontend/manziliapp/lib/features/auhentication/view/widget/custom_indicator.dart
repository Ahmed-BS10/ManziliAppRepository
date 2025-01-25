import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({Key? key, required this.dotIndex}) : super(key: key);
  final int dotIndex;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: 2,
      position: dotIndex,
      decorator: DotsDecorator(
        color: Colors.transparent,
        activeColor: pColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
