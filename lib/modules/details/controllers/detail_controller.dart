import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/photo_model.dart';

class DetailController extends GetxController {
  DetailController(this.photo);
  final PhotoModel photo;
  final isDownloading = false.obs;

  Future<void> download() async {
    if (isDownloading.value) return;
    isDownloading.value = true;
    try {
      final response = await Dio().get<List<int>>(
        photo.largeUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty)
        throw Exception('The image file was empty.');
      await Gal.putImageBytes(
        Uint8List.fromList(bytes),
        name: 'gallery_${photo.id}',
      );
      Get.snackbar(
        'Saved to gallery',
        'Your image has been saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Download failed',
        'Please check photo access and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  void share() => Share.share(
    '${photo.tags}\n${photo.largeUrl}',
    subject: 'Photo from Infinite Gallery',
  );
}
