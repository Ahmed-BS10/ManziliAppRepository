class StoreItem {
  final int id;
  final String imageUrl;
  final String businessName;
  final double rate;
  final List<String> categoryNames;
  final String status;

  StoreItem({
    required this.id,
    required this.imageUrl,
    required this.businessName,
    required this.rate,
    required this.categoryNames,
    required this.status,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      imageUrl: json['imageUrl'].toString().startsWith('/')
          ? "http://man.runasp.net" + json['imageUrl']
          : json['imageUrl'],
      businessName: json['businessName'],
      rate: (json['rate'] as num).toDouble(),
      categoryNames: (json['categoryNames'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      status: json['status'],
    );
  }
}
