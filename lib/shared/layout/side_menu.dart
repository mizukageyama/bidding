import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  SideMenu(this.menuItems, {Key? key}) : super(key: key);
  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: indigoColor,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const CircleImage(
              imageUrl: '',
            ),
            const SizedBox(
              height: 45,
              width: 45,
            ),
            alignMenuItems(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Column alignMenuItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...displayItems()],
    );
  }

  List<SideMenuCard> displayItems() {
    return menuItems.map((item) => SideMenuCard(menu: item)).toList();
  }
}
