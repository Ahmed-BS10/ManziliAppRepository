import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_indicator.dart';
import 'package:manziliapp/features/auhentication/view/widget/custom_page_view.dart';
import 'package:manziliapp/features/auhentication/view/widget/terms_and_privacy_checbok.dart';

class ProducerRegistrationForm extends StatefulWidget {
  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final bool isAgreed;
  final Function(bool) onAgreementChanged;
  final int currentIndex;

  const ProducerRegistrationForm({
    super.key,
    required this.pageController,
    required this.formKey,
    required this.isAgreed,
    required this.onAgreementChanged,
    required this.currentIndex,
  });

  @override
  State<ProducerRegistrationForm> createState() =>
      _ProducerRegistrationFormState();
}

class _ProducerRegistrationFormState extends State<ProducerRegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: CustomPageView(pageController: widget.pageController),
        ),
        TermsAndPrivacyCheckbox(
          onChanged: (value) {
            widget.onAgreementChanged(value);
          },
        ),
        const SizedBox(height: 10),
        CustomIndicator(dotIndex: widget.currentIndex),
        CustomTextButton(
          onPressed: () {
            if (widget.formKey.currentState!.validate()) {
              if (widget.isAgreed) {
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
                  ),
                );
              }
            }
          },
          name: widget.currentIndex == 1 ? 'التسجيل' : 'التالي',
          fontColor: Colors.white,
          backColor: pColor,
        ),
      ],
    );
  }
}
