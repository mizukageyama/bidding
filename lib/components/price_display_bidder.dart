import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/material.dart';

class DisplayPriceBidder extends StatelessWidget {
  const DisplayPriceBidder(
      {Key? key, required this.bidsController, required this.askingPrice})
      : super(key: key);
  final BidsController bidsController;
  final double askingPrice;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bidsController.isDoneLoading.value &&
          bidsController.bids.isNotEmpty) {
        int index = bidsController.approvedBid(bidsController.bids);
        if (index != -1) {
          return DisplayInfo(
            title: 'Highest Approved Bid',
            content: '₱ ${Format.amount(bidsController.bids[index].amount)}',
            isPrice: true,
          );
        }
        return DisplayInfo(
          title: 'Asking Price',
          content: '₱ ${Format.amount(askingPrice)}',
          isPrice: true,
        );
      } else if (bidsController.isDoneLoading.value &&
          bidsController.bids.isEmpty) {
        return DisplayInfo(
          title: 'Asking Price',
          content: '₱ ${Format.amount(askingPrice)}',
          isPrice: true,
        );
      }
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: maroonColor,
        ),
      );
    });
  }
}
