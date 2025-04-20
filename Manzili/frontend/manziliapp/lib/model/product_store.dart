class ProductStore {
  final String id;
  final String name;
  final int price;
  final double rating;
  final String imageUrl;
  final bool isFavorite;

  ProductStore({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
