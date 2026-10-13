class PhotoModel {
  final int id;
  final String previewUrl;
  final String imageUrl;
  final String largeUrl;
  final String tags;
  final String user;
  final int likes;
  final int views;

  const PhotoModel({required this.id, required this.previewUrl, required this.imageUrl, required this.largeUrl, required this.tags, required this.user, required this.likes, required this.views});

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
    id: json['id'] as int? ?? 0,
    previewUrl: json['previewURL'] as String? ?? '',
    imageUrl: json['webformatURL'] as String? ?? '',
    largeUrl: json['largeImageURL'] as String? ?? json['webformatURL'] as String? ?? '',
    tags: json['tags'] as String? ?? 'Beautiful photo',
    user: json['user'] as String? ?? 'Unknown photographer',
    likes: json['likes'] as int? ?? 0,
    views: json['views'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {'id': id, 'previewURL': previewUrl, 'webformatURL': imageUrl, 'largeImageURL': largeUrl, 'tags': tags, 'user': user, 'likes': likes, 'views': views};
}
