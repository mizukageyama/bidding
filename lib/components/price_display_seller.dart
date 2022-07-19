import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/material.dart';

class DisplayPriceSeller extends StatelessWidget {
  const DisplayPriceSeller(
      {Key? key,
      required this.bidsController,
      required this.askingPrice,
      required this.item})
      : super(key: key);
  final BidsController bidsController;
  final double askingPrice;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bidsController.isDoneLoading.value &&
          bidsController.bids.isNotEmpty) {
        int index = bidsController.approvedBid(bidsController.bids);
        if (index != -1) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DisplayInfo(
                title: 'Highest Approved Bid',
                content:
                    '₱ ${Format.amount(bidsController.bids[index].amount)}',
                isPrice: true,
              ),
              const SizedBox(
                width: 30,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => BidListScreen(
                        item: item,
                      ),
                    );
                  },
                  child: Text(
                    'View Bids',
                    style: robotoMedium.copyWith(
                        color: maroonColor,
                        decoration: TextDecoration.underline,
                        fontSize: 16),
                  ),
                ),
              )
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DisplayInfo(
              title: 'Asking Price',
              content: '₱ ${Format.amount(askingPrice)}',
              isPrice: true,
            ),
            const SizedBox(
              width: 30,
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => BidListScreen(
                      item: item,
                    ),
                  );
                },
                child: Text(
                  'View Bids',
                  style: robotoMedium.copyWith(
                      color: maroonColor,
                      decoration: TextDecoration.underline,
                      fontSize: 16),
                ),
              ),
            )
          ],
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
