class Store {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final bool isFavorite;
  final String location;
  final bool isOpen;
  final String about;
  final String deliveryTime;
  final List<String> phoneNumbers;
  final String whatsapp;
  final String instagram;
  final List<String> categories;

  Store({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    this.isFavorite = false,
    required this.location,
    required this.isOpen,
    required this.about,
    required this.deliveryTime,
    required this.phoneNumbers,
    required this.whatsapp,
    required this.instagram,
    required this.categories,
  });

  // Factory method to create a sample store
  factory Store.sample() {
    return Store(
      id: '1',
      name: 'متجر الأسر المنتجة',
      logo: 'assets/images/logo.png',
      rating: 4.6,
      location: 'فوة المتضررين',
      isOpen: true,
      about: 'متجر لوني يقدم لك منتجات منزلية عالية الجودة مصنوعة بحب وإتقان. '
          'نوفر لك أنواع المنتجات، مثل: المأكولات، المشغولات اليدوية، الملابس. '
          'لمسة فريدة تعكس أصالة الحرف اليدوية. '
          'تسوق الآن واستمتع بمنتجات مميزة وبسعر لا يُقاوم!',
      deliveryTime: 'يتم التسليم خلال يومين',
      phoneNumbers: ['+967 7777777'],
      whatsapp: '+967 7777777',
      instagram: 'ck_storeApp',
      categories: ['مأكولات', 'حرف يدوية', 'مأكولات'],
    );
  }
}

