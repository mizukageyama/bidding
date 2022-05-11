import 'package:flutter/material.dart';

class MenuItem {
  MenuItem(
      {required this.name,
      this.icon = Icons.dashboard,
      this.iconPath = '',
      required this.screen});

  final String name;
  final IconData icon;
  final String iconPath;
  final Widget screen;
}
