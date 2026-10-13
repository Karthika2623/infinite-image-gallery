import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/photo_model.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../controllers/detail_controller.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.photo});

  final PhotoModel photo;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      DetailController(photo),
      tag: 'detail-${photo.id}',
    );

    final favorites = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: const Color(0xFF11111A),
      body: CustomScrollView(
        slivers: [
          // Image and app bar
          SliverAppBar(
            backgroundColor: const Color(0xFF11111A),
            foregroundColor: Colors.white,
            pinned: true,
            expandedHeight: Responsive.detailImageHeight(context),
            actions: [
              IconButton(
                onPressed: controller.share,
                icon: const Icon(Icons.ios_share_rounded),
              ),
              Obx(
                () => IconButton(
                  onPressed: () => favorites.toggle(photo),
                  icon: Icon(
                    favorites.isFavorite(photo)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: const Color(0xFFFF718B),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'photo-${photo.id}',
                child: CachedNetworkImage(
                  imageUrl: photo.largeUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, url, error) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Photo information
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.isDesktop(context)
                      ? 900
                      : double.infinity,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.horizontalPadding(context) + 4,
                    26,
                    Responsive.horizontalPadding(context) + 4,
                    36,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF11111A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(26),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'PHOTO DETAILS',
                          style: TextStyle(
                            color: Color(0xFFBDB7FF),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Photo tags
                      Text(
                        photo.tags
                            .split(',')
                            .map((tag) => tag.trim())
                            .take(3)
                            .join(' · '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Photographer
                      Text(
                        'Captured and shared by ${photo.user}',
                        style: const TextStyle(
                          color: Color(0xFFAAAABC),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Likes and views
                      Row(
                        children: [
                          _stat(
                            Icons.favorite_outline,
                            '${photo.likes}',
                            'Likes',
                          ),
                          const SizedBox(width: 26),
                          _stat(
                            Icons.visibility_outlined,
                            '${photo.views}',
                            'Views',
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Download button
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            onPressed: controller.isDownloading.value
                                ? null
                                : controller.download,
                            icon: controller.isDownloading.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.download_rounded),
                            label: Text(
                              controller.isDownloading.value
                                  ? 'Saving image...'
                                  : 'Download image',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Image description is based on the tags '
                        'provided by Pixabay.',
                        style: TextStyle(
                          color: Color(0xFF85859A),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable photo statistic widget
  Widget _stat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFBDB7FF), size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF85859A), fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
