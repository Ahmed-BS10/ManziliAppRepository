import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key, required this.dotIndex});
  final int dotIndex;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
        dotsCount: 2,
        position: dotIndex,
        decorator: DotsDecorator(
          activeColor: pColor,
          color: Colors.grey[300]!,
          activeSize: Size(30.0, 8.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ));
  }
}
