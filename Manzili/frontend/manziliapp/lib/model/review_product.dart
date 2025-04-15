class ReviewProduct {
  final String name;
  final int rating;
  final String date;
  final String comment;
  final String avatar;
  
  const ReviewProduct({
    required this.name,
    required this.rating,
    required this.date,
    required this.comment,
    required this.avatar,
  });
  
  factory ReviewProduct.fromJson(Map<String, dynamic> json) {
    return ReviewProduct(
      name: json['userName'] as String,
      rating: json['ratingValue'] as int,
      date: json['createdAt'] as String,
      comment: json['comment'] as String,
      avatar: json['userImage'] as String,
    );
  }
  
}