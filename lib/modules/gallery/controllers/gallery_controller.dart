import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../../data/services/pixabay_service.dart';

class GalleryController extends GetxController {
  final GalleryRepository _repository = GalleryRepository(PixabayService());
  final photos = <PhotoModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final query = ''.obs;
  final category = ''.obs;
  final scrollController = ScrollController();
  int _page = 1;
  bool _hasMore = true;
  Timer? _debounce;

  @override
  void onInit() { super.onInit(); scrollController.addListener(_onScroll); loadInitial(); }
  void _onScroll() {
    if (!scrollController.hasClients || isLoading.value || isLoadingMore.value || !_hasMore) return;
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) loadMore();
  }

  Future<void> loadInitial() async {
    _page = 1; _hasMore = true; errorMessage.value = ''; isLoading.value = true;
    try { final result = await _repository.getPhotos(page: _page, query: query.value, category: category.value); photos.assignAll(result); _hasMore = result.length >= 30; }
    catch (e) { errorMessage.value = _cleanError(e); }
    finally { isLoading.value = false; }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try { final result = await _repository.getPhotos(page: _page + 1, query: query.value, category: category.value); if (result.isEmpty) { _hasMore = false; } else { _page++; photos.addAll(result); _hasMore = result.length >= 30; } }
    catch (_) { Get.snackbar('Could not load more', 'Check your connection and scroll again.', snackPosition: SnackPosition.BOTTOM); }
    finally { isLoadingMore.value = false; }
  }

  void search(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), loadInitial);
  }
  void selectCategory(String value) { category.value = value == 'All' ? '' : value.toLowerCase(); loadInitial(); }
  Future<void> refresh() => loadInitial();
  String _cleanError(Object e) => e.toString().replaceFirst('Exception: ', '').replaceFirst('DioException [connection error]: ', 'Network error: ');
  @override
  void onClose() { _debounce?.cancel(); scrollController.dispose(); super.onClose(); }
}
