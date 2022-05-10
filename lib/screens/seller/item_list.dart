import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(), sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final ItemListController itemListController = Get.put(ItemListController());

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
                  'Ongoing Auctions',
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
            searchBar(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'POSTED ITEMS',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 20,
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
        SizedBox(
          width: 300,
          child: TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              isDense: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: whiteColor,
              filled: true,
              label: const Text(
                'Search item here...',
                style: TextStyle(fontSize: 15),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text('Dropdown (Temporary)'),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            child: const Text('Search (Temporary)'),
            onPressed: () {
              print('Search button is pressed.');
            }),
      ],
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
      );

  @override
  Widget? tablet() => ItemLayoutGrid(
        perColumn: 3,
        item: item,
      );

  @override
  Widget? desktop() => ItemLayoutGrid(
        perColumn: 4,
        item: item,
      );
}
