import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/auctioned_items_controller.dart';
import 'package:bidding/main/seller/controllers/manage_item.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidListScreen extends StatelessWidget {
  const BidListScreen({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: ResponsiveView(
          _Content(
            item: item,
          ),
          SellerSideMenu(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  _Content({Key? key, required this.item}) : super(key: key);
  final AuctionedItemController aController = Get.find();
  final BidsController bidsController = Get.find();
  Item item;

  Item getItem() {
    item = aController.itemList
        .firstWhere((val) => val.itemId == item.itemId, orElse: () => item);
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: maroonColor,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: whiteColor,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Bid History',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: getItem().winningBid != '',
                    child: CustomButton(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                                ManageItem.otpDialog(getItem(), context));
                      },
                      text: 'Mark as Sold',
                      buttonColor: fadeColor,
                      fontColor: indigoColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(kIsWeb ? 20 : 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: whiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: kIsWeb && Get.width >= 600 ? 2 : 1,
                            child: Text(
                              'Bidder',
                              style: robotoMedium.copyWith(color: blackColor),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Amount',
                              style: robotoMedium.copyWith(color: blackColor),
                            ),
                          ),
                          Get.width >= 600
                              ? Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Expanded(
                                        flex: kIsWeb ? 3 : 2,
                                        child: Text(
                                          'Bid Date',
                                          style: robotoMedium.copyWith(
                                              color: blackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 70,
                            child: Text(
                              'Action',
                              style: robotoMedium.copyWith(color: blackColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => BidTile(
                              bid: bidsController.bids[index],
                              showAll: true,
                              isBidder: false,
                              item: getItem(),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: bidsController.bids.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
