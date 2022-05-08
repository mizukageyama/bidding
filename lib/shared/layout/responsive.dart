import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/side_menu.dart';
import 'package:flutter/material.dart';

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
