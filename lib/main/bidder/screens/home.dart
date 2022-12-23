import 'package:bidding/components/_components.dart';
import 'package:bidding/components/notification_card.dart';
import 'package:bidding/main/bidder/controllers/bidder_side_menu_controller.dart';
import 'package:bidding/main/bidder/controllers/ongoing_auction_controller.dart';
import 'package:bidding/main/bidder/screens/_bidder_screens.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/notif_controller.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidderHome extends StatelessWidget {
  const BidderHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
          BidderSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final notifScroll = ScrollController(initialScrollOffset: 0);
  final OngoingAuctionController itemListController = Get.find();
  final NotifController notifController = Get.find();
  final RxBool showNotif = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(children: [
        Container(
          color: maroonColor,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: Get.width < 600,
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  const Text(
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
              Flexible(
                child: Obx(
                  () => notifIcon(context),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    Column(
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
                                  Flexible(
                                    child: Text(
                                      kIsWeb
                                          ? 'Start bidding to your \nfavorite items now!'
                                          : 'Start bidding to your favorite items now!',
                                      style: robotoBold.copyWith(
                                          color: whiteColor,
                                          fontSize: kIsWeb ? 45 : 41),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Start your Bid and Win your favorite item.',
                                style: robotoMedium.copyWith(
                                    color: whiteColor, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BidderSideMenuController menu = Get.find();
                                  menu.changeActiveItem('Ongoing Auctions');
                                  Get.to(() => const OngoingAuctionScreen());
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: whiteColor)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'View Ongoing Auctions',
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
                          height: 10,
                        ),
                        Center(child: Obx(() => auctionsItems())),
                      ],
                    ),
                  ]),
              Obx(
                () => Visibility(
                  visible: showNotif.value,
                  child: Positioned(
                    right: 3,
                    top: 0,
                    child: Card(
                      color: Colors.white.withOpacity(0.70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 200,
                            maxHeight: context.height - 200,
                          ),
                          child: BlurryContainer(
                            blur: 5,
                            color: Colors.white.withOpacity(0.6),
                            width: 250,
                            child: showNotifs(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  //auctions item
  Widget auctionsItems() {
    if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isNotEmpty) {
      return ListView(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(kIsWeb ? 15 : 12),
          shrinkWrap: true,
          children: [
            Text(
              'Most Recent Auctions',
              style: robotoMedium.copyWith(color: blackColor, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            _ResponsiveItemGrid(
              item: itemListController.itemList,
            ),
          ]);
    } else if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: InfoDisplay(message: 'No ongoing auctions at the moment'));
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: maroonColor,
        ),
      ),
    );
  }

  Widget notifIcon(BuildContext context) {
    return Badge(
      showBadge: notifController.notifBadgeCount != 0,
      position: BadgePosition.topEnd(top: 1, end: 3),
      badgeContent: Text(
        '${notifController.notifBadgeCount}',
        style: const TextStyle(color: whiteColor),
      ),
      child: IconButton(
        onPressed: () {
          if (!showNotif.value) {
            notifController.resetBadge();
          }
          showNotif.value = !showNotif.value;
        },
        icon: const Icon(
          Icons.notifications_outlined,
          size: 25,
          color: whiteColor,
        ),
      ),
    );
  }

  Widget showNotifs() {
    if (notifController.isDoneLoading.value &&
        notifController.notifs.isNotEmpty) {
      return ListView.builder(
        controller: notifScroll,
        itemCount: notifController.notifs.length,
        padding: const EdgeInsets.all(kIsWeb ? 10 : 10),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return NotificationCard(
            notif: notifController.notifs[index],
          );
        },
      );
    } else if (notifController.isDoneLoading.value &&
        notifController.notifs.isEmpty) {
      return const Center(
        child: InfoDisplay(message: 'You have no notifications'),
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: maroonColor,
          ),
        ),
      ),
    );
  }
}

class _ResponsiveItemGrid extends GetResponsiveView {
  _ResponsiveItemGrid({Key? key, required this.item})
      : super(key: key, alwaysUseBuilder: false);

  final RxList<Item> item;

  @override
  Widget? phone() =>
      ItemLayoutGrid(perColumn: 2, item: item, isSoldItem: false, oneRow: true);

  @override
  Widget? tablet() =>
      ItemLayoutGrid(perColumn: 3, item: item, isSoldItem: false, oneRow: true);

  @override
  Widget? desktop() =>
      ItemLayoutGrid(perColumn: 4, item: item, isSoldItem: false, oneRow: true);
}
