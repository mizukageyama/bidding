import 'package:bidding/components/image_view.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class TableRowTile extends StatelessWidget {
  const TableRowTile(
      {Key? key, required this.rowData, required this.functionTap})
      : super(key: key);
  final List<String> rowData;
  final Function() functionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageView(
            imageUrl: rowData[0],
            isContained: false,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rowData[1],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rowData[2],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rowData[3],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rowData[4],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                rowData[5],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rowData[6],
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: InkWell(
              onTap: () {
                functionTap();
              },
              child: Text(
                'View',
                style: robotoMedium.copyWith(
                  color: maroonColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
