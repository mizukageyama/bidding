import 'package:bidding/main/admin/controllers/admin_side_menu_controller.dart';
import 'package:bidding/main/admin/controllers/closed_auction_controller.dart';
import 'package:bidding/main/admin/controllers/open_auction_controller.dart';
import 'package:bidding/main/admin/controllers/sold_auction_controller.dart';
import 'package:bidding/main/admin/screens/open_auctions.dart';
import 'package:bidding/main/admin/screens/side_menu.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AdminSideMenu(),
        body: ResponsiveView(
          const _Content(),
          const MobileSliver(
            title: 'Admin Dashboard',
            body: _Content(),
          ),
          AdminSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OpenAuctionController openListController = Get.find();
    final SoldAuctionController soldItemsController = Get.find();
    final ClosedAuctionController closedItemsController = Get.find();

    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        children: [
          kIsWeb && Get.width >= 600
              ? Container(
                  color: maroonColor,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Dashboard',
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
              child: ListView(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: pinkColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      kIsWeb
                                          ? 'View item\nand its status'
                                          : 'View items\nand its status',
                                      style: robotoBold.copyWith(
                                          color: whiteColor,
                                          fontSize: kIsWeb ? 45 : 42),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'See the University of Mindanao\'s Auction Community.',
                                  style: robotoMedium.copyWith(
                                      color: whiteColor, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    AdminSideMenuController menu = Get.find();
                                    menu.changeActiveItem('Open Auctions');
                                    Get.to(() => const OpenAuctionScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: whiteColor)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'See Ongoing Auctions',
                                          style: robotoMedium.copyWith(
                                              color: whiteColor, fontSize: 14),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Application Data',
                            style: robotoRegular.copyWith(
                              color: greyColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 149,
                                  decoration: BoxDecoration(
                                    color: fadeColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ongoing Auctions',
                                          style: robotoMedium.copyWith(
                                              color: whiteColor, fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 30),
                                        Center(
                                            child: Obx(
                                          () => Text(
                                            openListController.oCount == 0
                                                ? '--'
                                                : '${openListController.oCount}',
                                            style: robotoMedium.copyWith(
                                                color: whiteColor,
                                                fontSize: 30),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: 149,
                                  decoration: BoxDecoration(
                                    color: orangeColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Closed Auctions',
                                          style: robotoMedium.copyWith(
                                              color: whiteColor, fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 30),
                                        Center(
                                            child: Obx(
                                          () => Text(
                                            closedItemsController.cCount == 0
                                                ? '--'
                                                : '${closedItemsController.cCount}',
                                            style: robotoMedium.copyWith(
                                                color: whiteColor,
                                                fontSize: 30),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  height: 149,
                                  decoration: BoxDecoration(
                                    color: maroonColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sold Auctions',
                                          style: robotoMedium.copyWith(
                                              color: whiteColor, fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 30),
                                        Center(
                                          child: Obx(
                                            () => Text(
                                              soldItemsController.sCount == 0
                                                  ? '--'
                                                  : '${soldItemsController.sCount}',
                                              style: robotoMedium.copyWith(
                                                  color: whiteColor,
                                                  fontSize: 30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ],
                ),
              ])),
        ],
      ),
    );
  }
}
