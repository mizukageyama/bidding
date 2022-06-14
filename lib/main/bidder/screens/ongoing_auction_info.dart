import 'package:bidding/components/_components.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OngoingAuctionInfoScreen extends StatelessWidget {
  const OngoingAuctionInfoScreen({Key? key, required Item item})
      : _item = item,
        super(key: key);
  final Item _item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveView(
          _Content(
            item: _item,
          ),
          BidderSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key, required this.item}) : super(key: key);
  final Item item;
  final BidsController bidsController = Get.put(BidsController());

  @override
  Widget build(BuildContext context) {
    bidsController.bindBidList(item.itemId);

    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kIsWeb && Get.width >= 600
              ? Container(
                  color: maroonColor,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        'Ongoing Auctions > ${item.title}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: whiteColor,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          kIsWeb && Get.width >= 600
              ? Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LeftColumn(
                              images: item.images,
                            ),
                          ),
                          Expanded(
                            child: RightColumn(
                                item: item,
                                controller: bidsController,
                                isBidder: true),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      LeftColumn(
                        images: item.images,
                      ),
                      RightColumn(
                          item: item,
                          controller: bidsController,
                          isBidder: true)
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
