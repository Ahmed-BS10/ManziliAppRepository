// import 'package:flutter/material.dart';
// import 'package:manziliapp/model/order.dart';
// import 'package:manziliapp/widget/store_order_detalis/customer_info_widget.dart';
// import 'package:manziliapp/widget/store_order_detalis/order_note_widget.dart';
// import 'package:manziliapp/widget/store_order_detalis/order_summary_widget.dart';
// import 'package:manziliapp/widget/store_order_detalis/product_list_widget.dart';


// class StoreOrderDetailsView extends StatelessWidget {
//   final Order order;

//   const StoreOrderDetailsView({
//     Key? key,
//     required this.order,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   CustomerInfoWidget(
//                     customer: order.customer,
//                     orderId: order.id,
//                     orderDate: order.date,
//                   ),
//                   OrderNoteWidget(note: order.note),
//                   ProductListWidget(products: order.products),
//                   OrderSummaryWidget(
//                     subtotal: order.subtotal,
//                     deliveryFee: order.deliveryFee,
//                     discount: order.discount,
//                     total: order.total,
//                     status: order.status,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     Color backgroundColor;
//     String title;

//     switch (order.status) {
//       case OrderStatus.new_order:
//         backgroundColor = const Color(0xFF2962FF); // Royal blue color
//         title = 'طلب جديد';
//         break;
//       case OrderStatus.ongoing:
//         backgroundColor = const Color(0xFF2962FF);
//         title = 'طلب حالي';
//         break;
//       case OrderStatus.completed:
//         backgroundColor = const Color(0xFF2962FF);
//         title = 'طلب مكتمل';
//         break;
//       case OrderStatus.cancelled:
//         backgroundColor = const Color(0xFF2962FF);
//         title = 'طلب ملغي';
//         break;
//       case OrderStatus.in_progress:
//         // TODO: Handle this case.
//         throw UnimplementedError();
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       color: backgroundColor,
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 16,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Color(0xFF2962FF), size: 16),
//                 padding: EdgeInsets.zero,
//                 onPressed: () {},
//               ),
//             ),
//             const Spacer(),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             const SizedBox(width: 32), // For balance
//           ],
//         ),
//       ),
//     );
//   }
// }