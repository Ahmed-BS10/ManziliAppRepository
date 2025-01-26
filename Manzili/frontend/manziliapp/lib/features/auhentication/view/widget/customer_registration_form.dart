import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/features/auhentication/view/widget/personal_info_page.dart';
import 'package:manziliapp/features/auhentication/view/widget/terms_and_privacy_checbok.dart';

class CustomerRegistrationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isAgreed;
  final Function(bool) onAgreementChanged;
  final VoidCallback onFormSubmit;

  const CustomerRegistrationForm({
    super.key,
    required this.formKey,
    required this.isAgreed,
    required this.onAgreementChanged,
    required this.onFormSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PersonalInfoPage(),
        TermsAndPrivacyCheckbox(
          onChanged: (value) {
            onAgreementChanged(value);
          },
        ),
        CustomTextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (isAgreed) {
                onFormSubmit();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة'),
                  ),
                );
              }
            }
          },
          name: 'تسجيل الدخول',
          fontColor: Colors.white,
          backColor: pColor,
        ),
      ],
    );
  }
}
