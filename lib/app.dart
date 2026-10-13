import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class InfiniteGalleryApp extends StatelessWidget {
  const InfiniteGalleryApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Pixelspace Gallery',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialRoute: AppRoutes.gallery,
    getPages: AppPages.pages,
  );
}
