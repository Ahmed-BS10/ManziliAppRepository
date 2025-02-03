import 'package:flutter/material.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/features/auhentication/view/widget/customer_registration_form.dart';
import 'package:manziliapp/features/auhentication/view/widget/producer_registration_form.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool isAgreed = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeaderText(),
            if (userType == 'customer')
              CustomerRegistrationForm(
                formKey: _formKey,
                isAgreed: isAgreed,
                onAgreementChanged: (value) {
                  setState(() {
                    isAgreed = value;
                  });
                },
              )
            else
              ProducerRegistrationForm(
                pageController: _pageController,
                formKey: _formKey,
                isAgreed: isAgreed,
                onAgreementChanged: (value) {
                  setState(() {
                    isAgreed = value;
                  });
                },
                currentIndex: currentIndex,
              ),
          ],
        ),
      ),
    );
  }

  Widget BuildHeaderText() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        'يرجى إكمال جميع المعلومات\nلإنشاء حسابك على منزلي',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
