import 'package:bidding/main/admin/screens/open_closed_view.dart';
import 'package:bidding/main/admin/screens/sold_view.dart';
import 'package:flutter/material.dart';

class ItemViewer extends StatelessWidget {
  const ItemViewer({Key? key, required this.isSoldItem, required this.item})
      : super(key: key);
  final bool isSoldItem;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    if (isSoldItem) {
      return SafeArea(
        child: Scaffold(body: SoldItemView(item: item)),
      );
    }
    return SafeArea(child: Scaffold(body: OpenClosedItemView()) //item: item)),
        );
  }
}
