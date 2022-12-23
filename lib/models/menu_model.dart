import 'package:flutter/material.dart';

class SMenuItem {
  SMenuItem(
      {required this.name,
      this.icon = Icons.dashboard,
      this.iconPath = '',
      required this.function});

  final String name;
  final IconData icon;
  final String iconPath;
  final Function() function;
}
