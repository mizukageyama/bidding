import 'package:bidding/components/_components.dart';
import 'package:bidding/models/bid_model.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class DisplayBids extends StatelessWidget {
  const DisplayBids(
      {Key? key,
      required this.bidsController,
      required this.isBidder,
      required this.item})
      : super(key: key);
  final BidsController bidsController;
  final bool isBidder;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bidsController.isDoneLoading.value &&
          bidsController.bids.isNotEmpty) {
        if (isBidder) {
          List<Bid> filtered = RxList<Bid>.from(bidsController.filtered());
          if (filtered.isNotEmpty) {
            return SizedBox(
              width: Get.height * .65,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 45, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: neutralColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length > 5 ? 5 : filtered.length,
                      itemBuilder: (context, index) {
                        return BidTile(
                          bid: filtered[index],
                          isBidder: isBidder,
                          item: item,
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      color: maroonColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Highest Bids',
                            style: robotoRegular.copyWith(color: whiteColor),
                          ),
                          Visibility(
                            visible: !isBidder,
                            child: Text(
                              'Status',
                              style: robotoRegular.copyWith(color: whiteColor),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            );
          } else {
            return InfoDisplay(
                message: 'There are ${bidsController.bids.length} '
                    '${bidsController.bids.length > 1 ? 'bids' : 'bid'}  '
                    'for this item waiting for the seller\'s approval.');
          }
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.height * .65,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 45, bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: neutralColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bidsController.bids.length > 5
                            ? 5
                            : bidsController.bids.length,
                        itemBuilder: (context, index) {
                          return BidTile(
                            bid: bidsController.bids[index],
                            isBidder: isBidder,
                            item: item,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                        color: maroonColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      height: 40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Highest Bids',
                              style: robotoRegular.copyWith(color: whiteColor),
                            ),
                            Text(
                              'Status',
                              style: robotoRegular.copyWith(color: whiteColor),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: (!isBidder &&
                    DateTime.now().isAfter(item.endDate.toDate()) &&
                    item.winningBid.isEmpty),
                child: const InfoDisplay(
                    message: 'Note: View bids and select your final winner'),
              )
            ],
          );
        }
      } else if (bidsController.isDoneLoading.value &&
          bidsController.bids.isEmpty) {
        return const InfoDisplay(
            message: 'No bids for this item at the moment');
      }
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );
    });
  }
}
