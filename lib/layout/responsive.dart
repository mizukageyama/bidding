import 'package:bidding/layout/side_menu.dart';
import 'package:bidding/models/_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveView extends GetResponsiveView {
  ResponsiveView(this.content, this.menuItems, {Key? key})
      : super(key: key, alwaysUseBuilder: false);
  final Widget content;
  final List<MenuItem> menuItems;

  @override
  Widget? phone() => content;

  @override
  Widget? tablet() => Row(
        children: [
          Expanded(flex: 2, child: SideMenu(menuItems)),
          Expanded(flex: 5, child: content),
        ],
      );

  @override
  Widget? desktop() => Row(
        children: [
          Expanded(child: SideMenu(menuItems)),
          Expanded(flex: 5, child: content),
        ],
      );
}
