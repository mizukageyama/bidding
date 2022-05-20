import 'package:bidding/controllers/bids_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/components/right_column_content.dart';
import 'package:flutter/material.dart';

class RightColumn extends StatelessWidget {
  const RightColumn(
      {Key? key,
      required this.item,
      required this.controller,
      required this.isBidder})
      : super(key: key);
  final BidsController controller;
  final Item item;
  final bool isBidder;

  @override
  Widget build(BuildContext context) {
    return RightColumnContent(
      item: item,
      controller: controller,
      isBidder: isBidder,
    );
  }
}
