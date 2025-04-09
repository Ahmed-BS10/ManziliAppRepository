import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/store_controller.dart';
import 'package:manziliapp/core/helper/text_styles.dart';
import 'package:manziliapp/view/store_details_view.dart';

class StoreListSection extends StatelessWidget {
  final int? category;
  final String? filter;

  const StoreListSection({Key? key, this.category, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoreController storeController = Get.put(StoreController());

    // Fetch stores when the widget is built
    storeController.fetchStores(category: category, filter: filter);

    return Obx(() {
      if (storeController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (storeController.errorMessage.isNotEmpty) {
        return Center(child: Text("Error: ${storeController.errorMessage}"));
      } else if (storeController.stores.isEmpty) {
        return const Center(child: Text("No stores available."));
      } else {
        final stores = storeController.stores;
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: stores.map((store) {
              final statusMap = storeController.mapStatus(store.status);
              return InkWell(
                onTap: () => Get.to(() => StoreDetailsView()),
                child: StoreListItem(
                  storeId: store.id,
                  title: store.businessName,
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
    });
  }
}

class StoreListItem extends StatelessWidget {
  final int storeId;
  final String title;
  final String rating;
  final String status;
  final Color statusColor;
  final String? imageUrl;
  final List<String> categoryNames;

  const StoreListItem({
    Key? key,
    required this.storeId,
    required this.title,
    required this.rating,
    required this.status,
    required this.statusColor,
    required this.imageUrl,
    required this.categoryNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 9),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoreImage(imageUrl: imageUrl ?? 'assets/image/ad1.jpeg'),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.linkStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _StatusIndicator(status: status, color: statusColor),
                    const SizedBox(height: 6),
                    _CategoryIndicators(categories: categoryNames),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating, style: TextStyles.timeStyle),
                ],
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(status, style: TextStyles.linkStyle),
      ],
    );
  }
}

class _CategoryIndicators extends StatelessWidget {
  final List<String> categories;

  const _CategoryIndicators({Key? key, required this.categories})
      : super(key: key);

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
                color: const Color.fromARGB(255, 174, 202, 231),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: TextStyles.linkStyle,
              ),
            ),
          )
          .toList(),
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
          image: AssetImage(imageUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
