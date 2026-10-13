import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/photo_card.dart';
import '../../details/views/detail_screen.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();
    final horizontal = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your collection', style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.isCompact(context) ? 18 : 20)),
        leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: Obx(() {
            final items = controller.favorites.values.toList();
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(horizontal + 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 86, height: 86,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .09), shape: BoxShape.circle),
                        child: const Icon(Icons.favorite_border_rounded, size: 42, color: AppColors.primary),
                      ),
                      const SizedBox(height: 18),
                      const Text('Your favorites live here', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      const Text('Tap the heart on any photo to save it to your collection.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, height: 1.5)),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(horizontal),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridColumns(context),
                mainAxisSpacing: Responsive.isPhone(context) ? 10 : 16,
                crossAxisSpacing: Responsive.isPhone(context) ? 10 : 16,
                childAspectRatio: Responsive.gridAspectRatio(context),
              ),
              itemBuilder: (_, i) {
                final photo = items[i];
                return PhotoCard(
                  photo: photo,
                  favorite: true,
                  onTap: () => Get.to(() => DetailScreen(photo: photo)),
                  onFavorite: () => controller.toggle(photo),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
