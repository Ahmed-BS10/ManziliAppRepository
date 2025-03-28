// Models
class FullProduct {
  final String name;
  final String description;
  final String additionalInfo;
  final double basePrice;
  final List<String> images;
  final double rating;
  final String storeId;
  final String storeName;
  
  const FullProduct({
    required this.name,
    required this.description,
    required this.additionalInfo,
    required this.basePrice,
    required this.images,
    required this.rating,
    required this.storeId,
    required this.storeName,
  });
  
  // Factory method to create a sample product
  factory FullProduct.sample() {
    return const FullProduct(
      name: 'برجر لحم',
      description: '"برجر لذيذ مصنوع من لحم طازج 100%، مع جبن ذائب وخضار طازجة داخل خبز طري،"',
      additionalInfo: 'لمنحك تجربة طعم لا تُقاوم! 🔥🍔',
      basePrice: 148.0,
      images: [
        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-5mxJx9Ctvq0XS0mGDi3HUrcubIWSdo.png',
        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-5mxJx9Ctvq0XS0mGDi3HUrcubIWSdo.png',
        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/product%20page-5mxJx9Ctvq0XS0mGDi3HUrcubIWSdo.png',
      ],
      rating: 3.3,
      storeId: '1',
      storeName: 'متجر 1',
    );
  }
}