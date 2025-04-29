import 'package:flutter/material.dart';
import 'package:manziliapp/view/order_detalis_view.dart';
import 'package:manziliapp/widget/order_details/info_row.dart';
import 'package:manziliapp/widget/order_details/payment_details.dart';
import 'package:manziliapp/widget/order_details/section_title.dart';

class PaymentDetailsCard extends StatelessWidget {
  final PaymentDetails payment;
  final int numberOfProducts;

  const PaymentDetailsCard({
    super.key,
    required this.payment,
    required this.numberOfProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'تفاصيل الدفع'),
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
                label: 'إجمالي المنتجات ($numberOfProducts منتج)',
                value: '\$${(payment.productsTotal).toStringAsFixed(2)}',
              ),
              InfoRow(
                label: 'رسوم التوصيل',
                value: '\$${payment.deliveryFee.toStringAsFixed(2)}',
              ),
              const Divider(),
              InfoRow(
                label: 'الإجمالي',
                lableColor: Colors.black,
                value: '\$${payment.total.toStringAsFixed(2)}',
                isBold: true,
                valueColor: Colors.blue,
              ),
            ],
          ),
        )
      ],
    );
  }
}
