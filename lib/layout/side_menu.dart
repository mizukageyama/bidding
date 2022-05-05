import 'package:bidding/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu(this.menuItems, {Key? key}) : super(key: key);
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: Colors.grey,
      child: Column(
        children: [const Text('Side Menu'), ...displayItems()],
      ),
    );
  }

  List<Text> displayItems() {
    return menuItems.map((item) => Text(item.name)).toList();
  }
}
