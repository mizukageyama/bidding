import 'package:bidding/controllers/bids_controller.dart';
import 'package:bidding/shared/components/price_display_bidder.dart';
import 'package:bidding/shared/components/price_display_seller.dart';
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
