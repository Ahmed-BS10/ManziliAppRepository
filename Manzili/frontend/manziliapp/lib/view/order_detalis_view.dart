import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('تفاصيل الطلبات'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            OrderProgressStepper(
              steps: [
                OrderStep(title: 'التجهيز', isCompleted: true),
                OrderStep(title: 'الشحن', isCompleted: true),
                OrderStep(title: 'في الطريق', isCompleted: true),
                OrderStep(title: 'تم التسليم', isCompleted: false),
              ],
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'المنتجات'),
            const SizedBox(height: 8),
            ProductCard(
              product: ProductModel(
                name: 'برجر لحم',
                imageUrl:
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-5mxJx9Ctvq0XS0mGDi3HUrcubIWSdo.png',
                quantity: 5,
                price: 299,
              ),
            ),
            const SizedBox(height: 12),
            ProductCard(
              product: ProductModel(
                name: 'كيك منزلي',
                imageUrl:
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-5mxJx9Ctvq0XS0mGDi3HUrcubIWSdo.png',
                quantity: 20,
                price: 299,
              ),
            ),
            const SizedBox(height: 24),
            OrderInfoCard(
              info: OrderInfo(
                date: '16 يناير, 2025',
                deliveryAddress: 'المكلا - فوة ابن سينا',
                storeName: 'متجر الأسر المنتجة',
                deliveryTimeEstimate: 'من 1 إلى 2 أيام عمل',
              ),
            ),
            const SizedBox(height: 24),
            PaymentDetailsCard(
              payment: PaymentDetails(productsTotal: 200, deliveryFee: 8),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStep {
  final String title;
  final bool isCompleted;
  OrderStep({required this.title, required this.isCompleted});
}

class OrderProgressStepper extends StatelessWidget {
  final List<OrderStep> steps;
  const OrderProgressStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: steps.map((step) {
        return Column(
          children: [
            Icon(
              step.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: step.isCompleted ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(step.title),
          ],
        );
      }).toList(),
    );
  }
}

class ProductModel {
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;
  ProductModel({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عدد: ${product.quantity}'),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderInfo {
  final String date;
  final String deliveryAddress;
  final String storeName;
  final String deliveryTimeEstimate;
  OrderInfo({
    required this.date,
    required this.deliveryAddress,
    required this.storeName,
    required this.deliveryTimeEstimate,
  });
}

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

class PaymentDetails {
  final double productsTotal;
  final double deliveryFee;
  double get total => productsTotal + deliveryFee;
  PaymentDetails({required this.productsTotal, required this.deliveryFee});
}

class PaymentDetailsCard extends StatelessWidget {
  final PaymentDetails payment;
  const PaymentDetailsCard({super.key, required this.payment});

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
                label: 'إجمالي المنتجات (2)',
                value: '\$${payment.productsTotal.toStringAsFixed(2)}',
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

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  final Color? valueColor;
  final Color? lableColor;

  const InfoRow(
      {super.key,
      required this.label,
      required this.value,
      this.isBold = false,
      this.valueColor,
      this.lableColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: lableColor ?? Colors.blueGrey),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
