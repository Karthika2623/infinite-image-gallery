import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/photo_model.dart';

class PixabayService {
  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 20)));

  Future<List<PhotoModel>> fetchPhotos({required int page, String query = '', String category = ''}) async {
    if (ApiConstants.apiKey.isEmpty) {
      throw Exception(
        'Pixabay API key is missing. '
            'Run with --dart-define=PIXABAY_API_KEY=58019871-21017482383b7e02d6be0d25f',
      );
    }
    final response = await _dio.get(ApiConstants.baseUrl, queryParameters: {
      'key': ApiConstants.apiKey,
      'q': query.trim().isEmpty ? 'nature' : query.trim(),
      'image_type': 'photo',
      'category': category,
      'safesearch': true,
      'per_page': ApiConstants.perPage,
      'page': page,
      'order': 'popular',
    });
    final data = response.data;
    if (data is! Map<String, dynamic>) throw Exception('Unexpected response from image service.');
    final hits = data['hits'];
    if (hits is! List) throw Exception('Could not read images from the response.');
    return hits.whereType<Map<String, dynamic>>().map(PhotoModel.fromJson).toList();
  }
}
