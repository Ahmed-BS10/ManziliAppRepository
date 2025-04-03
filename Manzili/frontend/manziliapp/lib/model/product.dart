class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;
  final String category;
  final String subCategory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
    required this.subCategory,
  });

  get basePrice => null;

  // Factory method to create sample products
  static List<Product> sampleProducts() {
    return List.generate(
      4,
      (index) => Product(
        id: 'p${index + 1}',
        name: 'برجر لحم',
        description: 'برجر لحم مصنوع من أجود أنواع اللحوم ومعد بالفلفل ',
        price: 1700,
        image: 'assets/images/meat burger.jpg',
        rating: 4.6,
        category: 'مأكولات',
        subCategory: 'برجر',
      ),
    );
  }
}
