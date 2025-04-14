import 'package:flutter/material.dart';
import '../model/full_producta.dart';
import '../model/review_product.dart';
import '../widget/product/BottomBar.dart';
import '../widget/product/CommentButton.dart';
import '../widget/product/ImageCarousel.dart';
import '../widget/product/ProductDescription.dart';
import '../widget/product/ProductNameAndQuantity.dart';
import '../widget/product/RatingAndStoreInfo.dart';
import '../widget/product/RatingHeader.dart';
import '../widget/product/ReviewItem.dart';
import '../widget/product/TabSelector.dart';

// State Management
class ProductState {
  final FullProduct product;
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
    return product.basePrice * quantity;
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

// Main Product Detail Page
class ProductDetailView extends StatefulWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late ProductState _state;

  @override
  void initState() {
    super.initState();

    // Initialize state with available sizes
    _state = ProductState(
      product: FullProduct.sample(),
      reviews: ReviewProduct.getSampleReviews(),
      // Default to small size
    );
  }

  void _updateState(ProductState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with image carousel
          ImageCarousel(
            images: _state.product.images,
            currentIndex: _state.currentImageIndex,
            onPageChanged: (index) {
              _updateState(_state.copyWith(currentImageIndex: index));
            },
          ),

          // Tab navigation
          TabSelector(
            selectedTabIndex: _state.selectedTabIndex,
            onTabSelected: (index) {
              _updateState(_state.copyWith(selectedTabIndex: index));
            },
          ),

          // Content based on selected tab
          Expanded(
            child: _state.selectedTabIndex == 0
                ? ProductDetailsView(
                    state: _state,
                    onQuantityChanged: (quantity) {
                      _updateState(_state.copyWith(quantity: quantity));
                    },
                  )
                : ProductRatingsView(reviews: _state.reviews),
          ),

          // Bottom bar with price and add to cart button
          BottomBar(
            price: _state.calculatePrice(),
            onAddToCart: () {
              // Show a message with the selected size and price
              final price = _state.calculatePrice().toStringAsFixed(0);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تمت إضافة برجر لحم  إلى السلة بسعر \$$price',
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Product Ratings View
class ProductRatingsView extends StatelessWidget {
  final List<ReviewProduct> reviews;

  const ProductRatingsView({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Overall Rating
        const RatingHeader(totalReviews: 3),

        const SizedBox(height: 24),

        // Reviews List
        ...reviews.map((review) => ReviewItem(review: review)).toList(),

        const SizedBox(height: 24),

        // Comment Input
        const CommentButton(),

        const SizedBox(height: 32),
      ],
    );
  }
}

// Product Details View
class ProductDetailsView extends StatelessWidget {
  final ProductState state;
  final Function(int) onQuantityChanged;

  const ProductDetailsView({
    Key? key,
    required this.state,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Rating and Store Info
        RatingAndStoreInfo(
          rating: state.product.rating,
          storeName: state.product.storeName,
        ),

        const SizedBox(height: 24),

        // Product Name and Quantity in same line
        ProductNameAndQuantity(
          name: state.product.name,
          quantity: state.quantity,
          onIncrement: () => onQuantityChanged(state.quantity + 1),
          onDecrement: () {
            if (state.quantity > 1) {
              onQuantityChanged(state.quantity - 1);
            }
          },
        ),

        const SizedBox(height: 24),

        const SizedBox(height: 32),

        // Product Description
        ProductDescription(
          title: 'وصف المنتج',
          description: state.product.description,
          additionalInfo: state.product.additionalInfo,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
