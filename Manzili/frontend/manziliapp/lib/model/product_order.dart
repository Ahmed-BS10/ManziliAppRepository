class ProductOrder {
  final String name;
  final int quantity;
  final double price;

  ProductOrder({
    required this.name,
    required this.quantity,
    required this.price, required id,
  });

  double get total => quantity * price;
}