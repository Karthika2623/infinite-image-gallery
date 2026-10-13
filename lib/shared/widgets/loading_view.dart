import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GalleryLoadingView extends StatelessWidget {
  const GalleryLoadingView({super.key});
  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 8,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: .72,
    ),
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8F0),
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
