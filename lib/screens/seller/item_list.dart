import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/seller_side_menu.dart';
import 'package:flutter/material.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(), SellerSideMenu()),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final ItemListController itemListController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        children: [
          Container(
            color: maroonColor,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Auctioned Items',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: whiteColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                //searchBar()
              ],
            ),
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
          padding: const EdgeInsets.all(25),
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
