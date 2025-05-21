import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:manziliapp/core/widget/custom_text_bottun.dart';
import 'package:manziliapp/model/review_product.dart';
import 'package:manziliapp/view/add_product_review.dart';
import 'package:manziliapp/widget/product/RatingHeader.dart';
import 'package:manziliapp/widget/product/ReviewItem.dart';

class ProductRatingsView extends StatefulWidget {
  final int productId;
  final int reviewI;
  const ProductRatingsView(
      {super.key, required this.productId, required this.reviewI});

  @override
  _ProductRatingsViewState createState() => _ProductRatingsViewState();
}

class _ProductRatingsViewState extends State<ProductRatingsView> {
  List<ReviewProduct> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final url = Uri.parse(
        'http://man.runasp.net/api/Product/GetAllRatingsAndComments?productId=${widget.productId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['isSuccess'] == true) {
          setState(() {
            reviews = (responseData['data'] as List).map((item) {
              // Check if 'userImage' exists; if missing assign a default empty string or a placeholder.
              final avatar =
                  item.containsKey('userImage') && item['userImage'] != null
                      ? item['userImage']
                      : '';
              return ReviewProduct(
                name: item['userName'] ?? 'Unknown',
                rating: item['ratingValue'],
                date: item['createdAt'],
                comment: item['comment'] ?? '',
                avatar: avatar,
              );
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Get.snackbar('خطأ', responseData['message'] ?? 'خطأ في البيانات');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reviews: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب التقييمات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Overall Rating Header
        RatingHeader(
          totalReviews: widget.reviewI,
        ),
        const SizedBox(height: 24),
        // Reviews List or Loading/Error
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (reviews.isEmpty)
          const Center(
            child: Text(
              'No reviews available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          ...reviews.map((review) => ReviewItem(review: review)),
        const SizedBox(height: 24),
        // Button to Add New Review with auto-refresh support
        CustomTextButton(
          name: "اعطي لنا تقيم",
          backColor: const Color(0xFF1548c7),
          fontColor: Colors.white,
          onPressed: () async {
            // Wait for AddProductReviewView to finish and return a result.
            final result = await Get.to(() => AddProductReviewView(
                  productId: widget.productId,
                ));
            // If a review was successfully added, auto-refresh the reviews.
            if (result != null && result == true) {
              fetchReviews();
            }
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
