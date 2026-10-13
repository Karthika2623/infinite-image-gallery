import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/photo_model.dart';

class FavoritesController extends GetxController {
  static const _storageKey = 'favorite_photos_v1';
  final favorites = <int, PhotoModel>{}.obs;
  @override
  void onInit() { super.onInit(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List).whereType<Map<String, dynamic>>();
      favorites.assignAll({for (final item in list) (item['id'] as int): PhotoModel.fromJson(item)});
    } catch (_) { favorites.clear(); }
  }

  bool isFavorite(PhotoModel photo) => favorites.containsKey(photo.id);
  Future<void> toggle(PhotoModel photo) async {
    if (favorites.containsKey(photo.id)) { favorites.remove(photo.id); }
    else { favorites[photo.id] = photo; }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(favorites.values.map((p) => p.toJson()).toList()));
  }
}
