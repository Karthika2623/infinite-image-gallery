import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/photo_card.dart';
import '../../details/views/detail_screen.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../favorites/views/favorites_screen.dart';
import '../controllers/gallery_controller.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const categories = [
    'All', 'Nature', 'Travel', 'Architecture', 'Food', 'Animals', 'People'
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GalleryController>();
    final favorites = Get.find<FavoritesController>();
    final width = Responsive.width(context);
    final horizontal = Responsive.horizontalPadding(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, width < 360 ? 10 : 16, horizontal, 14),
                  child: Row(
                    children: [
                      Container(
                        width: width < 360 ? 40 : 46,
                        height: width < 360 ? 40 : 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .20), blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: const Icon(Icons.photo_library_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PIXELSPACE', style: TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.primary, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 3),
                            Text('Discover moments', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: Responsive.titleSize(context), fontWeight: FontWeight.w800, letterSpacing: -.5)),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Your favorites',
                        onPressed: () => Get.to(() => const FavoritesScreen()),
                        icon: const Icon(Icons.favorite_rounded, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  child: TextField(
                    onChanged: controller.search,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search photos, places, ideas...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: width < 360 ? 12 : 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: Obx(() {
                    final selectedCategory = controller.category.value;

                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: horizontal),
                      scrollDirection: Axis.horizontal,
                      children: categories.map((item) {
                        final selected =
                            (selectedCategory.isEmpty && item == 'All') ||
                                selectedCategory == item.toLowerCase();

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(item),
                            selected: selected,
                            onSelected: (_) => controller.selectCategory(item),
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : AppColors.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            showCheckmark: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.photos.isEmpty) return const GalleryLoadingView();
                    if (controller.errorMessage.value.isNotEmpty && controller.photos.isEmpty) {
                      return ErrorView(message: controller.errorMessage.value, onRetry: controller.loadInitial);
                    }
                    if (controller.photos.isEmpty) return const Center(child: Text('No photos found. Try another search.'));

                    return RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: CustomScrollView(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 12),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  final photo = controller.photos[index];
                                  return PhotoCard(
                                    photo: photo,
                                    favorite: favorites.isFavorite(photo),
                                    onTap: () => Get.to(() => DetailScreen(photo: photo)),
                                    onFavorite: () async {
                                      await favorites.toggle(photo);

                                      Get.snackbar(
                                        favorites.isFavorite(photo)
                                            ? 'Added to favorites'
                                            : 'Removed from favorites',
                                        photo.tags.split(',').first,
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 1),
                                      );
                                    },
                                  );
                                },
                                childCount: controller.photos.length,
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Responsive.gridColumns(context),
                                mainAxisSpacing: width < 600 ? 10 : 16,
                                crossAxisSpacing: width < 600 ? 10 : 16,
                                childAspectRatio: Responsive.gridAspectRatio(context),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Obx(() => controller.isLoadingMore.value
                                ? const Padding(padding: EdgeInsets.all(22), child: Center(child: CircularProgressIndicator()))
                                : const SizedBox(height: 18)),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
