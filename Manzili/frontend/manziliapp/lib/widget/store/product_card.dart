import 'package:flutter/material.dart';
import 'package:manziliapp/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // توسيع الفراغ الداخلي
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF1548C7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// **عمود السعر والسلة**
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5), // إزاحة السعر للأسفل قليلًا
                  child: Text(
                    '${product.price.toInt()} ريال', // جعل الريال بعد الرقم
                    style: const TextStyle(
                      color: Color(0xFF1548C7),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 20), // مسافة بين السعر والسلة
                Align(
                  alignment: Alignment.centerLeft, // إزاحة السلة لليسار قليلًا
                  child: Container(
                    margin: const EdgeInsets.only(right: 25), // تحريك السلة لليسار
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF1548C7), size: 30),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// **تفاصيل المنتج**
          Expanded(
            flex: 2, // مساحة أكبر لتفاصيل المنتج
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // اسم المنتج (إزاحة للأعلى)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11), // تحريك للأعلى
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF1548C7),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  const SizedBox(height: 4), // مسافة صغيرة

                  // وصف المنتج (إزاحة للأسفل)
                  Padding(
                    padding: const EdgeInsets.only(top: 8), // تحريك للأسفل
                    child: Text(
                      product.description,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// **صورة المنتج والتقييم**
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12), // حدود دائرية للصورة
                child: Image.network(
                  'assets/images/meat burger.jpg',
                  width: 100, // الحفاظ على حجم الصورة الأصلي
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100, // نفس أبعاد الصورة الأصلية
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              ),

              /// **تقييم المنتج**
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1548C7),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white, // حد أبيض للتباين
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );



  }
}

