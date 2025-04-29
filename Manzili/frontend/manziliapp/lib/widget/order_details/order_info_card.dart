import 'package:flutter/material.dart';
import 'package:manziliapp/view/order_detalis_view.dart';
import 'package:manziliapp/widget/order_details/info_row.dart';
import 'package:manziliapp/widget/order_details/order_info.dart';
import 'package:manziliapp/widget/order_details/section_title.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderInfo info;
  const OrderInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'تفاصيل الطلب:'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(
                label: 'تاريخ الطلب',
                value: info.date,
              ),
              InfoRow(
                label: 'عنوان التوصيل',
                value: info.deliveryAddress,
              ),
              InfoRow(label: 'اسم المتجر', value: info.storeName),
              InfoRow(
                label: 'الوقت المتوقع للتسليم',
                value: info.deliveryTimeEstimate,
              ),
            ],
          ),
        )
      ],
    );
  }
}
