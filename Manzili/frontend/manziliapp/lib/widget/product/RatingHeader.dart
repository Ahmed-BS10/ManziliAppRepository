import 'package:flutter/material.dart';




// Rating Header Component
class RatingHeader extends StatelessWidget {
  final int totalReviews;
  
  const RatingHeader({
    Key? key,
    required this.totalReviews,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text('3.3', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
              
              const Spacer(),
              const Text(
                'تقييم المنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0047FF),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end,
          
          children: [
            Text(
                  '$totalReviews تقييمات',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),textAlign: TextAlign.right,
                ),
          ],
        ),
        const SizedBox(height: 8),

        
        
       
      ],
    );
    
  }
}