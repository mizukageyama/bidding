import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/components/sold_item_card.dart';
import 'package:flutter/material.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';

class SoldItemLayoutGrid extends StatelessWidget {
  SoldItemLayoutGrid({Key? key, required this.perColumn, required this.item})
      : super(key: key);
  final int perColumn;
  final List<SoldItem> item;
  final List<TrackSize> sizePerColumn = List.empty(growable: true);
  final List<TrackSize> sizePerRow = List.empty(growable: true);

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
        for (var i = 0; i < item.length; i++) SoldItemCard(product: item[i]),
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
