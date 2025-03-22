import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  final Set<int> _favoriteStoreIds = {};

  FavoriteProvider() {
    _loadFavorites();
  }

  Set<int> get favoriteStoreIds => _favoriteStoreIds;

  bool isFavorite(int storeId) {
    return _favoriteStoreIds.contains(storeId);
  }

  Future<void> toggleFavorite(int storeId) async {
    // Toggle favorite locally
    if (_favoriteStoreIds.contains(storeId)) {
      _favoriteStoreIds.remove(storeId);
    } else {
      _favoriteStoreIds.add(storeId);
    }
    notifyListeners();

    // Save updated list locally using shared_preferences
    await _saveFavorites();

    // Call your backend endpoint
    String url =
        "http://man.runasp.net/api/StoreFavorite/ToggleFavorite?userId=3&storeId=$storeId";
    try {
      final response = await http.post(Uri.parse(url));
      final Map<String, dynamic> result = json.decode(response.body);

      if (result["isSuccess"] == true) {
        // Optionally handle success
      } else {
        // Optionally handle error (e.g., revert local state if needed)
      }
    } catch (error) {
      // If the network call fails, you might consider reverting the change:
      if (_favoriteStoreIds.contains(storeId)) {
        _favoriteStoreIds.remove(storeId);
      } else {
        _favoriteStoreIds.add(storeId);
      }
      notifyListeners();
      debugPrint("Error calling endpoint: $error");
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteStoreIds') ?? [];
    _favoriteStoreIds.addAll(favoriteIds.map(int.parse));
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favoriteStoreIds.map((id) => id.toString()).toList();
    await prefs.setStringList('favoriteStoreIds', favoriteIds);
  }
}
