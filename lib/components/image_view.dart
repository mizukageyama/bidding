import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.imageUrl,
    this.assetImage = 'assets/images/default_image.png',
    this.height = 50.0,
    this.width = 50.0,
    this.isContained = true,
  }) : super(key: key);

  final String imageUrl;
  final String assetImage;
  final double height;
  final double width;
  final bool isContained;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: isContained ? BoxFit.contain : BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          child: Image.asset(
            assetImage,
            fit: BoxFit.contain,
            width: width,
            height: height,
          ),
        );
      },
    );
  }
}
