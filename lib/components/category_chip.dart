import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({Key? key, required this.items}) : super(key: key);
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [...categories(items)],
    );
  }

  List<Chip> categories(List<String> items) {
    return items
        .map(
          (data) => Chip(
            backgroundColor: blackColor,
            label: Text(
              data,
              style: const TextStyle(color: whiteColor, fontSize: 13),
            ),
          ),
        )
        .toList();
  }
}
