import 'package:get/get.dart';
import '../controllers/gallery_controller.dart';
import '../../favorites/controllers/favorites_controller.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GalleryController());
    Get.put(FavoritesController(), permanent: true);
  }
}
