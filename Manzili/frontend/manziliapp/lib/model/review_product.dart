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
  
  // Factory method to create sample reviews
  static List<ReviewProduct> getSampleReviews() {
    return [
      ReviewProduct(
        name: 'أحمد محمد',
        rating: 5,
        date: '12 Feb, 2025',
        comment: 'برجر شهي بجودة عالية! اللحم طري ومقبل بشكل رائع، والجبن يذوب بطريقة مثالية. تجربة لذيذة تستحق التكرار 🍔',
        avatar: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-2-uIrNXKDkxfPyQYTNny6pb6eIzKVCkD.png',
      ),
      ReviewProduct(
        name: 'سارة علي',
        rating: 4,
        date: '10 Feb, 2025',
        comment: 'برجر لذيذ جداً، لكن كان يمكن أن يكون أفضل لو كان الخبز أكثر طراوة. سأطلبه مرة أخرى بالتأكيد.',
        avatar: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-2-uIrNXKDkxfPyQYTNny6pb6eIzKVCkD.png',
      ),
      ReviewProduct(
        name: 'محمد خالد',
        rating: 3,
        date: '5 Feb, 2025',
        comment: 'طعم جيد ولكن الحجم أصغر مما توقعت. الخدمة كانت سريعة.',
        avatar: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-2-uIrNXKDkxfPyQYTNny6pb6eIzKVCkD.png',
      ),
    ];
  }
}