import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoldItemList extends StatelessWidget {
  const SoldItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SellerSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Sold Items',
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
  final SoldItemsController soldItemsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                        'Sold Items',
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
                ),
          Expanded(child: Obx(() => showSoldItems())),
        ],
      ),
    );
  }

  Widget showSoldItems() {
    if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isNotEmpty) {
      return ListView(
          padding: const EdgeInsets.all(kIsWeb ? 25 : 12),
          shrinkWrap: true,
          children: [
            const Text(
              'Your Sold Items',
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
              item: soldItemsController.soldItems,
            ),
          ]);
    } else if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'You have no sold items yet'));
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

  final RxList<SoldItem> item;

  @override
  Widget? phone() => ItemLayoutGrid(
        perColumn: 2,
        item: item,
        isSoldItem: true,
      );

  @override
  Widget? tablet() => ItemLayoutGrid(
        perColumn: 3,
        item: item,
        isSoldItem: true,
      );

  @override
  Widget? desktop() => ItemLayoutGrid(
        perColumn: 4,
        item: item,
        isSoldItem: true,
      );
}
