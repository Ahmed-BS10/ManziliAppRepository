class PaymentDetails {
  final double productsTotal;
  final double deliveryFee;
  double get total => productsTotal + deliveryFee;
  PaymentDetails({required this.productsTotal, required this.deliveryFee});
}
