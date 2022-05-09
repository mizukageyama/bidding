import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SideMenuCard extends StatelessWidget {
  const SideMenuCard({Key? key, required this.menu}) : super(key: key);
  final MenuItem menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            menu.icon,
            color: whiteColor,
            size: 16,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            menu.name,
            style: const TextStyle(
                color: whiteColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}
