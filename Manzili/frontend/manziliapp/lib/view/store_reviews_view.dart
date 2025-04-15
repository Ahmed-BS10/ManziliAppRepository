import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/review.dart';
import 'package:manziliapp/widget/store%20reviews/rating_summary_section.dart';
import 'package:manziliapp/widget/store%20reviews/reviews_list_section.dart';
import 'add_review_view.dart';

class StoreReviewsView extends StatefulWidget {
  const StoreReviewsView({Key? key, required this.storeId}) : super(key: key);

  final int storeId;

  @override
  State<StoreReviewsView> createState() => _StoreReviewsViewState();
}

class _StoreReviewsViewState extends State<StoreReviewsView> {
  late Future<StoreReviewResponse?> _futureReviews;
  final userId = Get.find<UserController>().userId.value;

  @override
  void initState() {
    super.initState();
    _futureReviews = ReviewService.fetchStoreReviews(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<StoreReviewResponse?>(
        future: _futureReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            return Column(
              children: [
                // ✅ Rating summary
                RatingSummarySection(
                  averageRating: data.averageRating,
                  totalRatings: data.totalRatings,
                ),

                // ✅ Reviews list
                Expanded(
                  child: ReviewsListSection(
                    reviews: data.ratings,
                  ),
                ),

                // ✅ Add review button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddReviewView(storeId: widget.storeId, userId: userId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1548C7),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'أعطي لنا تقييمك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('حدث خطأ أثناء تحميل البيانات'));
          }
        },
      ),
    );
  }
}

