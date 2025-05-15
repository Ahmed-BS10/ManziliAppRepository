import 'package:flutter/material.dart';

import 'TabButton.dart';


// Tab Selector Component
class TabSelector extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;
  
  const TabSelector({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              text: 'تقييمات المنتج',
              isSelected: selectedTabIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TabButton(
              text: 'تفاصيل المنتج',
              isSelected: selectedTabIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
        ],
      ),
    );
  }
}