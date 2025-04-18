import 'dart:convert';

import 'package:http/http.dart' as http;

class StoreReviewResponse {
  final int storeId;
  final double averageRating;
  final int totalRatings;
  final List<Review> ratings;

  StoreReviewResponse({
    required this.storeId,
    required this.averageRating,
    required this.totalRatings,
    required this.ratings,
  });

  factory StoreReviewResponse.fromJson(Map<String, dynamic> json) {
    return StoreReviewResponse(
      storeId: json['storeId'],
      averageRating: (json['averageRating'] as num).toDouble(),
      totalRatings: json['totalRatings'],
      ratings: (json['ratings'] as List)
          .map((e) => Review.fromJson(e))
          .toList(),
    );
  }
}

class Review {
  final String userName;
  final String userImage;
  final int valueRate;
  final String date;

  Review({
    required this.userName,
    required this.userImage,
    required this.valueRate,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['userName'],
      userImage: json['imageUser'],
      valueRate: json['valueRate'],
      date: json['dateTime'].split('T').first,
    );
  }
}





class ReviewService {
  static Future<StoreReviewResponse?> fetchStoreReviews(int storeId) async {
    final url = 'http://man.runasp.net/api/StoreRating/store/$storeId/ratings';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['isSuccess']) {
        return StoreReviewResponse.fromJson(jsonData['data']);
      }
    }
    return null;
  }
}
