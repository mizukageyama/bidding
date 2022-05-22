import 'package:bidding/components/_components.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:flutter/material.dart';

class DisplayPrice extends StatelessWidget {
  const DisplayPrice(
      {Key? key,
      required this.isBidder,
      required this.bidsController,
      required this.askingPrice})
      : super(key: key);
  final bool isBidder;
  final BidsController bidsController;
  final double askingPrice;

  @override
  Widget build(BuildContext context) {
    if (isBidder) {
      return DisplayPriceBidder(
        bidsController: bidsController,
        askingPrice: askingPrice,
      );
    }
    return DisplayPriceSeller(
      bidsController: bidsController,
      askingPrice: askingPrice,
    );
  }
}
