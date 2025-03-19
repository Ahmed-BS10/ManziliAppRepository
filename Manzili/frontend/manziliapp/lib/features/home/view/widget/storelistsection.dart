import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

/// نموذج بيانات المتجر
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

/// قسم المتاجر مع إمكانية تمرير التصنيف المختار
class StoreListSection extends StatefulWidget {
  final int? category;
  final String? filter;

  const StoreListSection({Key? key, this.category, this.filter}) : super(key: key);

  @override
  _StoreListSectionState createState() => _StoreListSectionState();
}

class _StoreListSectionState extends State<StoreListSection> {
  late Future<List<StoreItem>> _storesFuture;

  @override
  void initState() {
    super.initState();
    _storesFuture = _fetchStores();
  }

  @override
  void didUpdateWidget(covariant StoreListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter || oldWidget.category != widget.category) {
      _storesFuture = _fetchStores();
    }
  }

  Future<List<StoreItem>> _fetchStores() async {
    String url;

    if (widget.filter != null) {
      switch (widget.filter) {
        case "المفضلة":
          url = "http://man.runasp.net/api/Store/GetUserFavoriteStores?userId=1";
          break;
        case "الجديدة":
          url = "http://man.runasp.net/api/Store/OrderByDescending";
          break;
        case "الكل":
          url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
          break;
        default:
          url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
      }
    } else if (widget.category != null) {
      url = "http://man.runasp.net/api/Store/StoresByCategore?storecCategoryId=${widget.category}";
    } else {
      url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse["isSuccess"] == true) {
        return (jsonResponse["data"] as List)
            .map((item) => StoreItem.fromJson(item))
            .toList();
      } else {
        throw Exception("Error: ${jsonResponse["message"]}");
      }
    } else {
      throw Exception("Failed to load: ${response.statusCode}");
    }
  }

  Map<String, dynamic> mapStatus(String status) {
    if (status.toLowerCase() == "open") {
      return {"text": "مفتوح", "color": AppColors.openStatus};
    } else if (status.toLowerCase() == "closed") {
      return {"text": "مغلق", "color": AppColors.closedStatus};
    }
    return {"text": status, "color": Colors.grey};
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<StoreItem>>(
      future: _storesFuture, // corrected here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No stores available."));
        } else {
          final stores = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: stores.map((store) {
                final statusMap = mapStatus(store.status);
                final category = store.categoryNames.isNotEmpty
                    ? store.categoryNames.first
                    : "";
                return StoreListItem(
                  title: store.businessName,
                  rating: store.rate.toStringAsFixed(1),
                  status: statusMap["text"],
                  statusColor: statusMap["color"],
                  imageUrl: store.imageUrl,
                  category: category,
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

/// عنصر عرض المتجر في القائمة
class StoreListItem extends StatefulWidget {
  
  final String title;
  final String rating;
  final String status;
  final Color statusColor;
  final String imageUrl;
  final String category;

  const StoreListItem({
    Key? key,
    required this.title,
    required this.rating,
    required this.status,
    required this.statusColor,
    required this.imageUrl,
    required this.category,
  }) : super(key: key);

  @override
  StoreListItemState createState() => StoreListItemState();
}

class StoreListItemState extends State<StoreListItem> {
  bool isFavorite = false; // تتبع حالة المفضلة
  bool isHovered = false; // تتبع حالة الـ hover

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey[200] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoreImage(imageUrl: widget.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // بيانات المتجر: الاسم، الحالة، والتصنيف
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyles.linkStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          _StatusIndicator(
                            status: widget.status,
                            color: widget.statusColor,
                          ),
                          const SizedBox(height: 6),
                          _CategoryIndicator(category: widget.category),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // أيقونة المفضلة والتقييم
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(widget.rating, style: TextStyles.timeStyle),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusIndicator({Key? key, required this.status, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(status, style: TextStyles.linkStyle),
      ],
    );
  }
}

class _CategoryIndicator extends StatelessWidget {
  final String category;

  const _CategoryIndicator({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.categoryBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(category, style: TextStyles.linkStyle),
    );
  }
}

class _StoreImage extends StatelessWidget {
  final String imageUrl;

  const _StoreImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.2,
      height: 87,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(ImageHelper.getImageUrl(imageUrl)),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
