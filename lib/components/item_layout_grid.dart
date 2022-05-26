import 'package:bidding/components/_components.dart';
import 'package:flutter/material.dart';
import 'package:bidding/shared/_packages_imports.dart';

class ItemLayoutGrid extends StatelessWidget {
  ItemLayoutGrid({
    Key? key,
    required this.perColumn,
    required this.item,
    required this.isSoldItem,
  }) : super(key: key);

  final List<TrackSize> sizePerColumn = List.empty(growable: true);
  final List<TrackSize> sizePerRow = List.empty(growable: true);
  final int perColumn;
  final List<dynamic> item;
  final bool isSoldItem;

  @override
  Widget build(BuildContext context) {
    int rowLength = getRowLength(item.length, perColumn);
    getSizes(rowLength);

    return LayoutGrid(
      columnGap: 15,
      columnSizes: sizePerColumn,
      rowGap: 15,
      rowSizes: sizePerRow,
      children: [
        for (var i = 0; i < item.length; i++)
          ItemCard(
            item: item[i],
            isSoldItem: isSoldItem,
          ),
      ],
    );
  }

  int getRowLength(int itemCount, int perColumn) {
    var rowLength = itemCount / perColumn;
    if (rowLength.runtimeType == double) {
      rowLength = rowLength.floor() + 1;
    }
    return rowLength.toInt();
  }

  void getSizes(int rowLength) {
    for (int a = 0; a < perColumn; a++) {
      sizePerColumn.add(1.fr);
    }

    for (int a = 0; a < rowLength; a++) {
      sizePerRow.add(auto);
    }
  }
}
