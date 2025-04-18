import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/product_detail_controller.dart';
import 'package:manziliapp/view/product_ratings_view.dart';
import 'package:manziliapp/widget/product/BottomBar.dart';
import 'package:manziliapp/widget/product/ImageCarousel.dart';
import 'package:manziliapp/widget/product/ProductDescription.dart';
import 'package:manziliapp/widget/product/ProductNameAndQuantity.dart';
import 'package:manziliapp/widget/product/RatingAndStoreInfo.dart';
import 'package:manziliapp/widget/product/TabSelector.dart';
import 'package:manziliapp/widget/product/product_details_view_body.dart';
import '../model/full_producta.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../model/full_producta.dart';

class ProductDetailView extends StatelessWidget {
  final int productId;

  const ProductDetailView({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller =
        Get.put(ProductDetailController());
    controller.fetchProductDetails(productId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final product = controller.product.value;

        return Column(
          children: [
            // Image Carousel
            ImageCarousel(
              images: product.images!,
              currentIndex: 0,
              onPageChanged: (index) {},
            ),

            // Tab Selector
            TabSelector(
              selectedTabIndex: controller.selectedTabIndex.value,
              onTabSelected: (index) {
                controller.updateTabIndex(index);
              },
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  return ProductDetailsViewBody(
                    product: product,
                    storeImage: product.storeImage,
                    quantity: controller.selectedQuantity.value,
                    onQuantityChanged: (quantity) {
                      controller.updateQuantity(quantity);
                    },
                  );
                } else if (controller.selectedTabIndex.value == 1) {
                  return ProductRatingsView(productId: product.id);
                } else {
                  return Container();
                }
              }),
            ),

            // Bottom Bar
            Obx(() => BottomBar(
                  price: controller.totalPrice,
                  onAddToCart: () {
                    final price = controller.totalPrice;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تمت إضافة ${product.name} إلى السلة بسعر $price ريال',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  },
                )),
          ],
        );
      }),
    );
  }
}

class ProductDetailController extends GetxController {
  final Dio _dio = Dio();
  final Rx<FullProducta> product = FullProducta().obs;
  final RxInt selectedQuantity = 1.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Existing product details fetch method
  Future<void> fetchProductDetails(int productId) async {
    try {
      isLoading.value = true;
      // Your existing product fetch implementation
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل بيانات المنتج';
    } finally {
      isLoading.value = false;
    }
  }

  // New add to cart method
  Future<bool> addToCart(
      int userId, int storeId, int productId, int quantity) async {
    try {
      final response = await _dio.get(
        'https://localhost:7175/api/Cart/add',
        queryParameters: {
          'userId': userId,
          'storeId': storeId,
          'productId': productId,
          'quantity': quantity,
        },
      );

      return response.data == true;
    } catch (e) {
      print('Error adding to cart: $e');
      throw e;
    }
  }

  void updateTabIndex(int index) => selectedTabIndex.value = index;
  void updateQuantity(int quantity) => selectedQuantity.value = quantity;
  double get totalPrice => product.value.price! * selectedQuantity.value;
}
