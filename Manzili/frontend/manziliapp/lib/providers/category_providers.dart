import 'package:flutter/foundation.dart';
import 'package:manziliapp/model/category_store.dart'; // Hide Flutter's Category class

class CategoryProvider with ChangeNotifier {
  final List<CategoryStore> _categories = [
    // Made final as suggested
    CategoryStore(id: '1', name: 'مأكولات'),
    CategoryStore(id: '2', name: 'حلويات'),
    CategoryStore(id: '3', name: 'معجنات'),
  ];

  List<CategoryStore> get categories => [..._categories];

  void addCategory(String name) {
    final newCategory = CategoryStore(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _categories.add(newCategory);
    notifyListeners();
  }

  // In a real app, you would implement methods to fetch categories from an API
  Future<void> fetchCategories() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, you would parse the response and update _categories
    notifyListeners();
  }
}
