import 'package:flutter/material.dart';
import 'package:manziliapp/core/constant/constant.dart';

class TermsAndPrivacyCheckbox extends StatefulWidget {
  const TermsAndPrivacyCheckbox({super.key});

  @override
  _TermsAndPrivacyCheckboxState createState() =>
      _TermsAndPrivacyCheckboxState();
}

class _TermsAndPrivacyCheckboxState extends State<TermsAndPrivacyCheckbox> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Row(
          children: [
            Text('أوافق على '),
            Text('شروط الاستخدام ', style: TextStyle(color: pColor)),
            Text('و '),
            Text('سياسة الخصوصية ', style: TextStyle(color: pColor)),
            Checkbox(
              value: _isAgreed,
              onChanged: (value) {
                setState(() {
                  _isAgreed = !_isAgreed;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
