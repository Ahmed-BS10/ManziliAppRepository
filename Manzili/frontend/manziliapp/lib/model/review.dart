class Review {
  final String id;
  final String userName;
  final String userImage;
  final int rating;
  final String date;
  final String? comment;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.date,
    this.comment,
  });

  // Factory method to create sample reviews
  static List<Review> sampleReviews() {
    return [
      Review(
        id: 'r1',
        userName: 'Ahmed Salah',
        userImage: 'assets/images/Guy.jpg',
        rating: 5,
        date: '30/3/25',
      ),
      Review(
        id: 'r2',
        userName: 'Ahmed Salah',
        userImage: 'assets/images/Guy.jpg',
        rating: 5,
        date: '30/3/25',
      ),
      Review(
        id: 'r3',
        userName: 'محمد علي',
        userImage: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-a7upSfEQOAI5cflvhy2p78oHYtqe5x.png', // Replace with actual image URL
        rating: 4,
        date: '25/3/25',
        comment: 'منتجات رائعة وخدمة ممتازة',
      ),
      Review(
        id: 'r4',
        userName: 'سارة أحمد',
        userImage: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-a7upSfEQOAI5cflvhy2p78oHYtqe5x.png', // Replace with actual image URL
        rating: 5,
        date: '20/3/25',
      ),
      Review(
        id: 'r5',
        userName: 'خالد محمود',
        userImage: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-a7upSfEQOAI5cflvhy2p78oHYtqe5x.png', // Replace with actual image URL
        rating: 3,
        date: '15/3/25',
        comment: 'المنتجات جيدة ولكن التوصيل متأخر قليلاً',
      ),
    ];
  }
}

