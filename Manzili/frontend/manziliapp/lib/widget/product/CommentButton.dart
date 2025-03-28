
import 'package:flutter/material.dart';


// Comment Button Component
class CommentButton extends StatelessWidget {
  const CommentButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        Navigator.of(context).pushNamed("WriteReview");
      },
      child: Container(
        height: 30,
       // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff555555)),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        child: const Text(
          'اكتب تعليقك',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
