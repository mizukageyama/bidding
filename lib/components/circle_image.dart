import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    this.imageUrl = '',
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
      borderRadius: BorderRadius.circular(height),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: kIsWeb ? height : 70,
        width: kIsWeb ? width : 70,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: kIsWeb ? height : 70,
            width: kIsWeb ? width : 70,
            child: Image.asset(
              assetImage,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
