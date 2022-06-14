import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class NoDisplaySearchResult extends StatelessWidget {
  const NoDisplaySearchResult({
    Key? key,
  }) : super(key: key);

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
          Flexible(
            child: Text(
              'No items matched with your search',
              style: robotoRegular.copyWith(
                color: blackColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
