import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class InfoDisplay extends StatelessWidget {
  const InfoDisplay({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: infoColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outlined,
            color: greyColor,
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
