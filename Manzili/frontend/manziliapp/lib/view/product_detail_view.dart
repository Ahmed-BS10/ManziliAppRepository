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
import '../model/full_producta.dart';

class ProductDetailView extends StatelessWidget {
  final int productId;

  const ProductDetailView({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller =
        Get.put(ProductDetailController());
    // جلب تفاصيل المنتج
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
            // معرض الصور
            ImageCarousel(
              images: product.images!,
              currentIndex: 0, // الصورة الافتراضية الأولى
              onPageChanged: (index) {
                // يمكن التعامل مع تغيير الصورة إذا لزم الأمر
              },
            ),

            // عنصر التبويبات
            TabSelector(
              selectedTabIndex: controller.selectedTabIndex.value,
              onTabSelected: (index) {
                controller.updateTabIndex(index);
              },
            ),

            // المحتوى المتغير بناءً على التبويب المحدد
            Expanded(
              child: Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  // تفاصيل المنتج
                  return ProductDetailsViewBody(
                    product: product,
                    storeImage: product.storeImage,
                    onQuantityChanged: (quantity) {
                      controller.updateQuantity(quantity);
                    },
                  );
                } else if (controller.selectedTabIndex.value == 1) {
                  // تقييمات المنتج
                  return ProductRatingsView(reviews: []); // استخدم بيانات التقييم الحقيقية عند توفرها
                } else {
                  return Container();
                }
              }),
            ),

            // شريط الأسفل الذي يُظهر السعر الإجمالي (المتغير تلقائيًا)
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

class ProductDetailsViewBody extends StatelessWidget {
  final ProductData product;
  final Function(int) onQuantityChanged;
  final String storeImage;

  const ProductDetailsViewBody({
    Key? key,
    required this.product,
    required this.onQuantityChanged,
    required this.storeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // عرض تقييم ومعلومات المتجر
        RatingAndStoreInfo(
          rating: 0,
          storeName: product.storeName,
          storeImage: storeImage,
        ),
        const SizedBox(height: 24),
        // اسم المنتج والكمية مع زر الزيادة والنقصان
        ProductNameAndQuantity(
          name: product.name,
          quantity: product.quantity,
          onIncrement: () => onQuantityChanged(product.quantity + 1),
          onDecrement: () {
            if (product.quantity > 1) {
              onQuantityChanged(product.quantity - 1);
            }
          },
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 32),
        // وصف المنتج
        ProductDescription(
          title: 'وصف المنتج',
          description: product.description,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
