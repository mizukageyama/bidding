import 'package:bidding/layout/components/_components.dart';
import 'package:bidding/layout/styles.dart';
import 'package:bidding/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu(this.menuItems, {Key? key}) : super(key: key);
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      height: Get.height,
      color: indigoColor,
      child: Column(
        children: [
          const CircleImage(),
          const SizedBox(
            height: 45,
          ),
          ...displayItems()
        ],
      ),
    );
  }

  List<Text> displayItems() {
    return menuItems
        .map((item) => Text(
              item.name,
              style: const TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ))
        .toList();
  }
}
