import 'package:firstsplashscreenview/firstsplashscreenview.dart';
import 'package:flutter/material.dart';
import 'package:manziliapp/CustomerViews/view/on_borading_view.dart';

class SplashsView extends StatelessWidget {
  const SplashsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.white,
      duration: const Duration(milliseconds: 3000),
      nextPage: const OnBoradingView(),
      iconBackgroundColor: Colors.white,
      circleHeight: 200,
      text: const Text(""),
      child: Image.asset(
        "assets/image/startimg.jpg",
        fit: BoxFit.fill,
      ),
    );
  }
}
