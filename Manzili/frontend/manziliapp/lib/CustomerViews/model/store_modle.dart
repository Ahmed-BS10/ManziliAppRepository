class StoreModle {
  final int id;
  final String? imageUrl;
  final String businessName;
  final double rate;
  final List<String> categoryNames;
  final String status;

  StoreModle({
    required this.id,
    required this.imageUrl,
    required this.businessName,
    required this.rate,
    required this.categoryNames,
    required this.status,
  });

  factory StoreModle.fromJson(Map<String, dynamic> json) {
    return StoreModle(
      id: json['id'],
      imageUrl: json['imageUrl'].toString().startsWith('/')
          ? "http://man.runasp.net" + json['imageUrl']
          : 'assets/image/ad1.jpeg',
      businessName: json['businessName'],
      rate: (json['rate'] as num).toDouble(),
      categoryNames: (json['categoryNames'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      status: json['status'],
    );
  }
}
