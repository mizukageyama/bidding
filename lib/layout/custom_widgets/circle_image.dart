import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 50,
        width: 50,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              'assets/images/profile.jpg', //default image
              fit: BoxFit.cover,
              height: 35,
              width: 35,
            ),
          );
        },
      ),
    );
  }
}
