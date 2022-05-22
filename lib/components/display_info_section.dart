import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class DisplayInfo extends StatelessWidget {
  const DisplayInfo(
      {Key? key,
      required this.title,
      required this.content,
      this.isPrice = false})
      : super(key: key);
  final String title;
  final String content;
  final bool isPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: robotoMedium.copyWith(
              color: blackColor,
              fontSize: 14,
            )),
        const SizedBox(
          height: 5,
        ),
        Text(
          content,
          style: isPrice
              ? robotoMedium.copyWith(color: orangeColor, fontSize: 25)
              : robotoRegular.copyWith(
                  color: greyColor,
                  fontSize: 14,
                ),
        )
      ],
    );
  }
}
