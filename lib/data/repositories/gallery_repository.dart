import '../models/photo_model.dart';
import '../services/pixabay_service.dart';

class GalleryRepository {
  GalleryRepository(this._service);
  final PixabayService _service;
  Future<List<PhotoModel>> getPhotos({required int page, String query = '', String category = ''}) =>
      _service.fetchPhotos(page: page, query: query, category: category);
}
