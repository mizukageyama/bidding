import 'package:bidding/components/_components.dart';
import 'package:flutter/material.dart';

class LeftColumn extends StatelessWidget {
  const LeftColumn({Key? key, required this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GalleryView(
        images: images,
      ),
    );
  }
}
