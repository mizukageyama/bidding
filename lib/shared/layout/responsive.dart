import 'package:bidding/shared/_packages_imports.dart';
import 'package:flutter/material.dart';

class ResponsiveView extends GetResponsiveView {
  ResponsiveView(this.content, this.phoneVersion, this.sideMenu, {Key? key})
      : super(key: key, alwaysUseBuilder: false);
  final Widget content;
  final Widget sideMenu;
  final Widget phoneVersion;

  @override
  Widget? phone() => phoneVersion;

  @override
  Widget? tablet() => Row(
        children: [
          Expanded(flex: 2, child: sideMenu),
          Expanded(flex: 5, child: content),
        ],
      );

  @override
  Widget? desktop() => Row(
        children: [
          Expanded(child: sideMenu),
          Expanded(flex: 5, child: content),
        ],
      );
}
