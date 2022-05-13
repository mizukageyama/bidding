import 'package:bidding/models/menu_model.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:flutter/material.dart';

class SideMenuItemList extends StatelessWidget {
  const SideMenuItemList({Key? key, required this.itemList}) : super(key: key);
  final List<MenuItem> itemList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemList.map((item) => SideMenuCard(menu: item)).toList(),
      ],
    );
  }
}
