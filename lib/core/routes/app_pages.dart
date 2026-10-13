import 'package:get/get.dart';
import '../../modules/gallery/bindings/gallery_binding.dart';
import '../../modules/gallery/views/gallery_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [GetPage(name: AppRoutes.gallery, page: () => const GalleryScreen(), binding: GalleryBinding())];
}
