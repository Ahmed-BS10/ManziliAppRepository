// import 'package:flutter/material.dart';
// import 'package:manziliapp/model/review.dart';

// class ReviewCard extends StatelessWidget {
//   final Review review;

//   const ReviewCard({
//     Key? key,
//     required this.review,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // User image
//           CircleAvatar(
//             radius: 24,
//             backgroundImage: NetworkImage(
//               'assets/images/Guy.jpg'
//             ),
//             onBackgroundImageError: (_, __) {},
//             child: const Icon(Icons.person, color: Colors.grey),
//           ),
//           const SizedBox(width: 12),

//           // Review content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // User name and rating
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       review.userName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Row(
//                       children: List.generate(5, (index) {
//                         return Icon(
//                           index < review.rating ? Icons.star : Icons.star_border,
//                           color: Colors.amber,
//                           size: 16,
//                         );
//                       }),
//                     ),
//                   ],
//                 ),

//                 // Review date
//                 Text(
//                   review.date,
//                   style: TextStyle(
//                     color: Colors.grey.shade400,
//                     fontSize: 20,
//                   ),
//                 ),

//                 // Review comment (if any)

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

