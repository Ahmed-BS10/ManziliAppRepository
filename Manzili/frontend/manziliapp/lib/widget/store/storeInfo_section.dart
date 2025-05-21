import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StoreInfoSection extends StatelessWidget {
  const StoreInfoSection({
    super.key,
    required this.rate,
    required this.businessName,
    required this.categoryNames,
  });

  final int rate;
  final String businessName;
  final List<String> categoryNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Store info (favorite, rating, name)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Favorite button
              IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: Color(0xFF1548C7), size: 35),
                onPressed: () {},
              ),
              // Rating with border only and left margin, smaller font and star
              Container(
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFF4F4F4), width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      rate.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Store name with icon before text and left offset
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(-45, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          businessName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 19),
                          textAlign: TextAlign.center,
                          
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.storefront,
                            color: Color(0xFF1548C7),
                            size: 31), // الأيقونة أولاً
                        const SizedBox(width: 6), // مسافة صغيرة بين الأيقونة والنص
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Categories display (non-clickable)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: categoryNames.map((category) {
              return Container(
                margin: const EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  color: Color(0xFFECF1F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // smaller padding
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12, // smaller font
                    color: Color(0xFF66707A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
