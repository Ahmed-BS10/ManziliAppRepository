
import 'package:flutter/material.dart';
import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/core/helper/image_helper.dart';
import 'package:manziliapp/core/helper/text_styles.dart';

class StoreListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: const [
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مفتوح",
            statusColor: AppColors.openStatus,
            imageUrl: "cvx26ypx.png",
          ),
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مغلق",
            statusColor: AppColors.closedStatus,
            imageUrl: "k1rwvj6p.png",
          ),
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مفتوح",
            statusColor: AppColors.openStatus,
            imageUrl: "cvx26ypx.png",
          ),
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مغلق",
            statusColor: AppColors.closedStatus,
            imageUrl: "k1rwvj6p.png",
          ),
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مفتوح",
            statusColor: AppColors.openStatus,
            imageUrl: "cvx26ypx.png",
          ),
          StoreListItem(
            title: "متجر الإسر المنتجة",
            rating: "4.6",
            status: "مغلق",
            statusColor: AppColors.closedStatus,
            imageUrl: "k1rwvj6p.png",
          ),
          // Add more store items as needed
        ],
      ),
    );
  }
}

class StoreListItem extends StatefulWidget {
  final String title;
  final String rating;
  final String status;
  final Color statusColor;
  final String imageUrl;

  const StoreListItem({
    super.key,
    required this.title,
    required this.rating,
    required this.status,
    required this.statusColor,
    required this.imageUrl,
  });

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
                        _CategoryIndicator(),
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

  const _StatusIndicator({required this.status, required this.color});

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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.categoryBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text("مأكولات", style: TextStyles.linkStyle),
    );
  }
}

class _StoreImage extends StatelessWidget {
  final String imageUrl;

  const _StoreImage({required this.imageUrl});

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
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
