import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class NoDisplaySearchResult extends StatelessWidget {
  const NoDisplaySearchResult({
    Key? key,
    required this.title,
    required this.message,
    required this.content,
  }) : super(key: key);
  final String title;
  final String message;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightgreyColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outlined,
            color: blackColor,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(content,
              style: robotoRegular.copyWith(
                color: blackColor,
                fontSize: 14,
              )),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: blackColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(message,
              style: robotoRegular.copyWith(
                color: blackColor,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}
