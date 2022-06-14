import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/auctioned_items_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuctionedItemListScreen extends StatelessWidget {
  const AuctionedItemListScreen({Key? key}) : super(key: key);

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

  final AuctionedItemController auctionedItemsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: maroonColor,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Auctioned Items',
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
          Expanded(child: Obx(() => showItems())),
        ],
      ),
    );
  }

  Widget showItems() {
    if (auctionedItemsController.isDoneLoading.value &&
        auctionedItemsController.itemList.isNotEmpty) {
      return ListView(
          padding: const EdgeInsets.all(kIsWeb ? 25 : 12),
          shrinkWrap: true,
          children: [
            const Text(
              'Your Listings',
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
              item: auctionedItemsController.itemList,
            ),
          ]);
    } else if (auctionedItemsController.isDoneLoading.value &&
        auctionedItemsController.itemList.isEmpty) {
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
}

class ResponsiveItemGrid extends GetResponsiveView {
  ResponsiveItemGrid({Key? key, required this.item})
      : super(key: key, alwaysUseBuilder: false);

  final RxList<Item> item;

  @override
  Widget? phone() => ItemLayoutGrid(
        perColumn: 2,
        item: item,
        isSoldItem: false,
      );

  @override
  Widget? tablet() => ItemLayoutGrid(
        perColumn: 3,
        item: item,
        isSoldItem: false,
      );

  @override
  Widget? desktop() => ItemLayoutGrid(
        perColumn: 4,
        item: item,
        isSoldItem: false,
      );
}
