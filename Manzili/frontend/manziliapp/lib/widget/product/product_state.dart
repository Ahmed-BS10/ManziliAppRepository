import 'package:manziliapp/model/full_producta.dart';
import 'package:manziliapp/model/review_product.dart';

class ProductState {
  final ProductData product;
  final List<ReviewProduct> reviews;
  int quantity;
  int selectedTabIndex;
  int currentImageIndex;

  ProductState({
    required this.product,
    required this.reviews,
    this.quantity = 1,
    this.selectedTabIndex = 0,
    this.currentImageIndex = 0,
  });

  // Calculate price based on size and quantity
  double calculatePrice() {
    return product.price.toDouble() * quantity;
  }

  // Create a copy with updated values
  ProductState copyWith({
    int? quantity,
    int? selectedTabIndex,
    int? currentImageIndex,
  }) {
    return ProductState(
      product: product,
      reviews: reviews,
      quantity: quantity ?? this.quantity,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }
}
