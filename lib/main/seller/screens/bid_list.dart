import 'package:bidding/components/_components.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidListScreen extends StatelessWidget {
  const BidListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Bid History',
            body: _Content(),
          ),
          SellerSideMenu(),
        ),
      ),
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
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
          Expanded(
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
                            flex: kIsWeb ? 2 : 1,
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
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: kIsWeb ? 3 : 2,
                            child: Text(
                              'Bid Date',
                              style: robotoMedium.copyWith(color: blackColor),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
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
