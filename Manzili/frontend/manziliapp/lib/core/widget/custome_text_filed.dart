import 'package:flutter/material.dart';

// class CustomeTextFiled extends StatelessWidget {
//   const CustomeTextFiled({
//     super.key,
//     this.hintText,
//     this.size = 50,
//     this.line = 1,
//     this.iconData,
//   });

//   final String? hintText;
//   final double? size;
//   final int? line;
//   final Widget? iconData;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: size,
//       child: TextFormField(
//         maxLines: line ?? 1,
//         textAlign: TextAlign.right,
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'الحقل فارغ';
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           suffixIcon: iconData,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             color: Colors.grey.shade400,
//             fontSize: 16,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16.0,
//             vertical: 12.0,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomeTextFiled extends StatelessWidget {
  const CustomeTextFiled(
      {super.key, this.hintText, this.size = 43, this.line = 1, this.iconData});

  final String? hintText;
  final double? size;
  final int? line;
  final Widget? iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: TextFormField(
          maxLines: line ?? 1,
          textAlign: TextAlign.right,
          validator: (value) {
            if (value!.isEmpty) {
              print('الحقل فارغ ');
            }
            return null;
          },
          decoration: InputDecoration(
            suffixIcon: iconData,
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF5FCF9),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0 * 1.5, vertical: 16.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
          )),
    );
  }
}
