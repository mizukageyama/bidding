import 'package:bidding/components/_components.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class DisplayBids extends StatelessWidget {
  const DisplayBids(
      {Key? key, required this.bidsController, required this.isBidder})
      : super(key: key);
  final BidsController bidsController;
  final bool isBidder;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bidsController.isDoneLoading.value &&
          bidsController.bids.isNotEmpty) {
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
                  itemCount: bidsController.bids.length > 5
                      ? 5
                      : bidsController.bids.length,
                  itemBuilder: (context, index) {
                    return BidTile(
                      bid: bidsController.bids[index],
                      isBidder: isBidder,
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
