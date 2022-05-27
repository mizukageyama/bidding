import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/controllers/ongoing_auction_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OngoingAuctionScreen extends StatelessWidget {
  const OngoingAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Ongoing Auctions',
            body: _Content(),
          ),
          BidderSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final OngoingAuctionController itemListController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        children: [
          kIsWeb && Get.width >= 600
              ? Container(
                  color: maroonColor,
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Ongoing Auctions',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              kIsWeb ? 20 : 12,
              20,
              kIsWeb ? 20 : 12,
              kIsWeb ? 0 : 5,
            ),
            child: searchBar(),
          ),
          Expanded(child: Obx(() => showItems())),
        ],
      ),
    );
  }

  Widget showItems() {
    if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isNotEmpty) {
      return ListView(
          padding: const EdgeInsets.all(kIsWeb ? 25 : 12),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            const Text(
              'AUCTIONED ITEMS',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ResponsiveItemGrid(
              item: itemListController.itemList,
            ),
          ]);
    } else if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'No items for auction at the moment'));
    }
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 45,
            child: InputField(
              labelText: 'Search item here...',
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                return;
              },
              onSaved: (value) => {},
              controller: TextEditingController(),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 120,
          height: 45,
          child: CustomButton(
            onTap: () {},
            text: 'Search',
            buttonColor: maroonColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class ResponsiveItemGrid extends GetResponsiveView {
  ResponsiveItemGrid({Key? key, required this.item, this.firstRowOnly = false})
      : super(key: key, alwaysUseBuilder: false);

  final RxList<Item> item;
  final bool firstRowOnly;

  @override
  Widget? phone() => ItemLayoutGrid(
      perColumn: 2, item: item, isSoldItem: false, oneRow: firstRowOnly);

  @override
  Widget? tablet() => ItemLayoutGrid(
      perColumn: 3, item: item, isSoldItem: false, oneRow: firstRowOnly);

  @override
  Widget? desktop() => ItemLayoutGrid(
      perColumn: 3, item: item, isSoldItem: false, oneRow: firstRowOnly);
}
