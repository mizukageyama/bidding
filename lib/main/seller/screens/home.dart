import 'package:bidding/components/info_display.dart';
import 'package:bidding/components/notification_card.dart';
import 'package:bidding/main/seller/controllers/auctioned_items_controller.dart';
import 'package:bidding/main/seller/controllers/seller_side_menu_controller.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/notif_controller.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: SellerSideMenu(),
        body: ResponsiveView(
          _Content(),
          SellerSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
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
          child: Stack(children: [
            ListView(
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(children: [
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
                                    kIsWeb && Get.width >= 600
                                        ? 'Start posting your \navailable items now'
                                        : 'Start posting your available items now',
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
                              'Start an auction within the University of Mindanao Community.',
                              style: robotoMedium.copyWith(
                                  color: whiteColor, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                SellerSideMenuController menu = Get.find();
                                menu.changeActiveItem('Add Item for Auction');
                                Get.to(() => const AddItemForm());
                              },
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: whiteColor)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Add Auction Item',
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
                        height: 7,
                      ),
                      Wrap(
                          runSpacing: 10,
                          runAlignment: WrapAlignment.spaceAround,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFb8fcff),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/auction_image.jpg',
                                  fit: BoxFit.contain,
                                  width: 750,
                                  height: 320,
                                ),
                              ),
                            ),
                            const DisplayStatus()
                          ])
                    ]),
                  ],
                ),
              ],
            ),
            Obx(() => Visibility(
                visible: showNotif.value,
                child: Positioned(
                  right: 0,
                  top: 0,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 250,
                      child: shownotifs(context),
                    ),
                  ),
                )))
          ]),
        )
      ]),
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

  Widget shownotifs(BuildContext context) {
    if (notifController.isDoneLoading.value &&
        notifController.notifs.isNotEmpty) {
      return ListView.builder(
        itemCount: notifController.notifs.length,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(kIsWeb ? 10 : 10),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return NotificationCard(notif: notifController.notifs[index]);
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

class DisplayStatus extends StatelessWidget {
  const DisplayStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuctionedItemController itemListController = Get.find();
    final SoldItemsController soldItemsController = Get.find();

    int getTotal() {
      return itemListController.itemList.length +
          soldItemsController.soldItems.length;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: <Widget>[
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Auctioned',
                          style: robotoMedium.copyWith(
                              color: whiteColor, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => Text(
                            getTotal() == 0 ? '--' : '${getTotal()}',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 30),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open Auctions',
                          style: robotoMedium.copyWith(
                              color: whiteColor, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => Text(
                            itemListController.oCount == 0
                                ? '--'
                                : '${itemListController.oCount}',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 30),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 149,
                  decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sold Items',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 16),
                            textAlign: TextAlign.left),
                        const SizedBox(height: 15),
                        Obx(
                          () => Text(
                            soldItemsController.soldItems.isEmpty
                                ? '--'
                                : '${soldItemsController.soldItems.length}',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 30),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: 149,
                  decoration: BoxDecoration(
                      color: redColor, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Closed Auctions',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 16),
                            textAlign: TextAlign.left),
                        const SizedBox(height: 15),
                        Obx(
                          () => Text(
                            itemListController.cCount == 0
                                ? '--'
                                : '${itemListController.cCount}',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 30),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
