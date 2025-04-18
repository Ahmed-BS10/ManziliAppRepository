import 'package:flutter/material.dart';
import 'package:manziliapp/CustomerViews/widget/start/start_view_body.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: StartViewBody(),
    );
  }
}
