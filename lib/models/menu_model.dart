import 'package:flutter/material.dart';

class MenuItem {
  MenuItem({required this.name, required this.icon, required this.screen});

  final String name;
  final IconData icon;
  final Widget screen;
}
