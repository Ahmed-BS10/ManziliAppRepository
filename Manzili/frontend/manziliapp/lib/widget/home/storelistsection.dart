import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/core/constant/constant.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/text_styles.dart';
import 'package:manziliapp/view/store_details_view.dart';
import 'package:manziliapp/widget/home/favorite_provider.dart';
import 'package:manziliapp/model/store_modle.dart';
import 'package:manziliapp/widget/store/store_image.dart';
import 'package:provider/provider.dart';

class StoreListSection extends StatefulWidget {
  final int? category;
  final String? filter;

  const StoreListSection({super.key, this.category, this.filter});

  @override
  _StoreListSectionState createState() => _StoreListSectionState();
}

class _StoreListSectionState extends State<StoreListSection> {
  late Future<List<StoreModle>> _storesFuture;

  @override
  void initState() {
    super.initState();
    _storesFuture = _fetchStores();
  }

  @override
  void didUpdateWidget(covariant StoreListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter ||
        oldWidget.category != widget.category) {
      _storesFuture = _fetchStores();
    }
  }

  Future<List<StoreModle>> _fetchStores() async {
    String url;

    if (widget.filter != null) {
      switch (widget.filter) {
        case "المفضلة":
          url =
              "http://man.runasp.net/api/Store/GetUserFavoriteStores?userId=${Get.find<UserController>().userId.value}";
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
      url =
          "http://man.runasp.net/api/Store/StoresByCategore?storecCategoryId=${widget.category}";
    } else {
      url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse["isSuccess"] == true) {
        return (jsonResponse["data"] as List)
            .map((item) => StoreModle.fromJson(item))
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

    return FutureBuilder<List<StoreModle>>(
      future: _storesFuture,
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
                return InkWell(
                  onTap: () => Get.to(() => StoreDetailsScreen(
                        storeId: store.id,
                      )),
                  child: StoreListItem(
                    storeId: store.id,
                    userName: store.UserName,
                    rating: store.rate.toStringAsFixed(1),
                    status: statusMap["text"],
                    statusColor: statusMap["color"],
                    imageUrl: store.imageUrl,
                    categoryNames: store.categoryNames,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class StoreListItem extends StatefulWidget {
  final int storeId;
  final String userName;
  final String rating;
  final String status;
  final Color statusColor;
  final String? imageUrl;
  final List<String> categoryNames;

  const StoreListItem({
    super.key,
    required this.storeId,
    required this.userName,
    required this.rating,
    required this.status,
    required this.statusColor,
    required this.imageUrl,
    required this.categoryNames,
  });

  @override
  StoreListItemState createState() => StoreListItemState();
}

class StoreListItemState extends State<StoreListItem> {
  bool isHovered = false;

  Future<void> _toggleFavorite() async {
    // Use the provider to toggle the favorite state
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    await favoriteProvider.toggleFavorite(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final bool isFavorite = favoriteProvider.isFavorite(widget.storeId);

    // ... rest of your build method remains the same
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey[200] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Card(
            elevation: isHovered ? 4 : 2,
            color: Colors.white, // Make the card background transparent
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.zero,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StoreImage(
                        imageUrl: widget.imageUrl,
                        width: 80,
                        height: 80,
                        borderRadius: 0, // Make the image squared (no rounding)
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: TextStyles.linkStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            _StatusIndicator(
                              status: widget.status,
                              color: widget.statusColor,
                            ),
                            const SizedBox(height: 6),
                            _CategoryIndicators(
                              categories: widget.categoryNames,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Favorite icon in the top left with left margin
                Positioned(
                  top: 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleFavorite,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                // Store rate in the bottom left with left margin
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating,
                          style: TextStyles.timeStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusIndicator(
      {super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    // Determine background color for open/closed
    Color? bgColor;
    Color? textColor = Colors.white;
    if (status == "مفتوح") {
      bgColor = Color(0xFF20D851);
    } else if (status == "مغلق") {
      bgColor = Colors.red;
    } else {
      bgColor = color.withOpacity(0.2);
      textColor = color;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Removed the colored dot before status text
        // const SizedBox(width: 6), // Remove extra spacing as well
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyles.linkStyle.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryIndicators extends StatelessWidget {
  final List<String> categories;

  const _CategoryIndicators({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: categories
          .map(
            (category) => Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFECF1F6),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(
                      0xFFECF1F6), // More obvious border color (blue)
                  width: 1.5, // Thicker border for more visibility
                ),
              ),
              child: Text(
                category,
                style: TextStyles.linkStyle.copyWith(
                  color: const Color(0xFF66707A),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
