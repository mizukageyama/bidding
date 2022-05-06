import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    required this.imageUrl,
    this.assetImage = 'assets/images/default_image.png',
    this.height = 50.0,
    this.width = 50.0,
  }) : super(key: key);

  final String imageUrl;
  final String assetImage;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: height,
            width: width,
            child: Image.asset(
              assetImage,
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
          );
        },
      ),
    );
  }
}
