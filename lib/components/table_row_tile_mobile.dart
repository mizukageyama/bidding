import 'package:bidding/components/image_view.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class TableRowTileMobile extends StatelessWidget {
  const TableRowTileMobile(
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
              child: InkWell(
                onTap: () => functionTap(),
                child: Text(
                  rowData[1],
                  style: robotoMedium.copyWith(
                    color: Colors.blue,
                  ),
                ),
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
        ],
      ),
    );
  }
}
