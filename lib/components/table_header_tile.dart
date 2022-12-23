import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class TableHeaderTile extends StatelessWidget {
  const TableHeaderTile({Key? key, required this.headerText}) : super(key: key);
  final List<String> headerText;

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: robotoMedium.copyWith(color: whiteColor),
      child: Container(
        color: maroonColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  headerText[0],
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  headerText[1],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  headerText[2],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  headerText[3],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  headerText[4],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  headerText[5],
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                headerText[6],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
