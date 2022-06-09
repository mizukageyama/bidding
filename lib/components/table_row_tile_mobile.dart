import 'package:flutter/material.dart';

class TableRowTileMobile extends StatelessWidget {
  const TableRowTileMobile({Key? key, required this.rowData}) : super(key: key);
  final List<Widget> rowData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rowData[0],
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: rowData[1],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: rowData[2],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: rowData[3],
                ),
              ),
            ],
          ),
          const Divider(
            height: 10,
          )
        ],
      ),
    );
  }
}
