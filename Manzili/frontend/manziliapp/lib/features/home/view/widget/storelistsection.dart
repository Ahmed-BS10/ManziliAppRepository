import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

/// Model class representing a store item from the API
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
      imageUrl:
          "http://man.runasp.net/Profile/141b71a37e0a4c94b5f9b3ba5af9097a.png",
      businessName: json['businessName'],
      rate: (json['rate'] as num).toDouble(),
      // Ensure categoryNames is a List<String>
      categoryNames: (json['categoryNames'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      status: json['status'],
    );
  }
}

/// The main widget which fetches store items from the API and displays them
class StoreListSection extends StatefulWidget {
  const StoreListSection({Key? key}) : super(key: key);

  @override
  _StoreListSectionState createState() => _StoreListSectionState();
}

class _StoreListSectionState extends State<StoreListSection> {
  late Future<List<StoreItem>> _storesFuture;
  final String _apiUrl =
      "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";

  @override
  void initState() {
    _storesFuture = _fetchStores();
    super.initState();
  }

  Future<List<StoreItem>> _fetchStores() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse["isSuccess"] == true) {
        final List<dynamic> data = jsonResponse["data"];
        return data.map((item) => StoreItem.fromJson(item)).toList();
      } else {
        throw Exception("API returned an error: ${jsonResponse["message"]}");
      }
    } else {
      throw Exception(
          "Failed to load stores. Status code: ${response.statusCode}");
    }
  }

  /// Converts API status and selects the appropriate color and Arabic text.
  Map<String, dynamic> _mapStatus(String status) {
    if (status.toLowerCase() == "open") {
      return {
        "text": "مفتوح",
        "color": AppColors.openStatus,
      };
    } else if (status.toLowerCase() == "closed") {
      return {
        "text": "مغلق",
        "color": AppColors.closedStatus,
      };
    }
    return {
      "text": status,
      "color": Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<StoreItem>>(
      future: _storesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the API
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error gracefully
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No stores available."));
        } else {
          final stores = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: stores.map((store) {
                final statusMap = _mapStatus(store.status);
                // Use the first category if available otherwise fallback to an empty string.
                final category = store.categoryNames.isNotEmpty
                    ? store.categoryNames.first
                    : "";
                return StoreListItem(
                  title: store.businessName,
                  rating: store.rate.toStringAsFixed(1),
                  status: statusMap["text"],
                  statusColor: statusMap["color"],
                  imageUrl:
                      "http://man.runasp.net/Profile/141b71a37e0a4c94b5f9b3ba5af9097a.png",
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

/// Updated StoreListItem now accepts a dynamic category value.
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
  bool isFavorite = false; // Track favorite state

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StoreImage(imageUrl: widget.imageUrl),
            const SizedBox(width: 16),
            // Expanded row: Left side = title & info; right side = favorite and rating column
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and additional data on left (in RTL means on the right side visually)
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
                  // Favorite icon and rating in a vertical column on the right
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

/// (_CategoryIndicator) now accepts a category string to display.
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
          image: NetworkImage(
            ImageHelper.getImageUrl(imageUrl),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
