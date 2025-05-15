import 'package:flutter/material.dart';

class StoreTabs extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  final String status;
  final String addrees;

  const StoreTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.status, required this.addrees,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location and status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
          child: SizedBox(
            height: 40, // تثبيت الارتفاع لضمان التناسق
            child: Stack(
              alignment: Alignment.center,
              children: [
                // حالة المتجر (مفتوح) - ستكون على اليسار
                Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: Offset(15, 0), // زيادة القيمة لتحريك العنصر لليمين
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF20D851),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                            color:
                                status == 'مفتوح' ? Colors.white : Colors.red,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),

                // موقع المتجر - مع إزاحة بسيطة لليمين
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: const Offset(25, 0), // إزاحة لليمين بمقدار 15 بكسل
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          addrees,
                          style: const TextStyle(
                              color: Color(0xFF1548C7),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.location_on,
                            color: Color(0xFF1548C7), size: 35),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom navigation tabs
        Container(
          child: Row(
            children: [
              _buildNavTab('سياسة المتجر', 2), // من اليمين أولًا
              _buildNavTab('تقييمات المتجر', 1),
              _buildNavTab('منتجاتنا', 3),
              _buildNavTab('عن المتجر', 0), // يصبح الأخير على اليسار
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavTab(String title, int index) {
    final isSelected = index == selectedTabIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin:
              const EdgeInsets.symmetric(horizontal: 4), // <-- أضف هذا السطر
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1548C7) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF1548C7) : Colors.grey,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF1548C7).withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1548C7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
