import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/bid_tile.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/seller_side_menu.dart';
import 'package:flutter/material.dart';

class BidListScreen extends StatelessWidget {
  const BidListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(), SellerSideMenu()),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final BidsController bidsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: maroonColor,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: Get.width,
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                            flex: 2,
                            child: Text(
                              'Bidder',
                              style: robotoRegular.copyWith(color: greyColor),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Amount',
                              style: robotoRegular.copyWith(color: greyColor),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Bid Date',
                              style: robotoRegular.copyWith(color: greyColor),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Text(
                              'Action',
                              style: robotoRegular.copyWith(color: greyColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ListView.separated(
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BidTile(
                              bid: bidsController.bids[index],
                              showAll: true,
                              isBidder: false,
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: bidsController.bids.length,
                        ),
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
