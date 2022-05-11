import 'dart:js';

import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/info_display.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class ItemInfoScreen extends StatelessWidget {
  const ItemInfoScreen({Key? key}) //, required Item item})
      : //_item = item,
        super(key: key);

  //final Item _item;

  @override
  Widget build(BuildContext context) {
    //print(_item.toJson());

    return Scaffold(
      body: ResponsiveView(_Content(), sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  //const _Content({Key? key, required this.item}) : super(key: key);

  final Item item = Item(
    itemId: "MsRyfhQOhK2IwiSaNT94",
    sellerId: "iebjbHvazId6UbXVEcloCQ9bSXt1",
    title: "RaspBerry Pi, and Arduino Sensors",
    description:
        "TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED",
    askingPrice: 450,
    category: ["Arduino", "Electronics"],
    condition: "Used",
    brand: "",
    endDate: Timestamp(1652263200, 0),
    images: [
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F1.png?alt=media&token=7cf24a74-2e55-42b1-8d36-d6880bb438ef",
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F4.jpg?alt=media&token=5cda5722-e54e-4539-805d-8cd646f1d27e",
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F3.jpg?alt=media&token=fba1557f-149f-4ba0-9ea9-3639a2992e03",
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F2.jpg?alt=media&token=19cf633e-68d8-4232-a862-7dffa8919532",
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F6.jpg?alt=media&token=6b366f16-4be2-43d4-b553-9ef6a5deb24f",
      "https://firebasestorage.googleapis.com/v0/b/bidding-4af0e.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2F5.jpg?alt=media&token=aa2d034d-0ad1-4f51-a930-27b2ff6b01db"
    ],
  );

  final BidsController bidsController = Get.put(BidsController());
  final RxList<Bid> itemList = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    itemList.bindStream(bidsController.getBids(item.itemId));
    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
    });

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
              children: [
                const Icon(
                  Icons.arrow_back_outlined,
                  color: whiteColor,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  'Auctioned Items > ${item.title}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: whiteColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(child: leftColumn()),
              Expanded(child: rightColumn()),
            ],
          ),
        ],
      ),
    );
  }

  Widget leftColumn() {
    return Container(
      color: neutralColor,
      height: Get.height - 55,
      child: Column(
        children: [],
      ),
    );
  }

  Widget rightColumn() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: Get.height - 55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title.toUpperCase(),
            style: robotoBold.copyWith(
              color: maroonColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          displayInfo('Description', item.description),
          const SizedBox(
            height: 15,
          ),
          item.brand == ''
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayInfo('Brand', item.brand),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          Flexible(
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [...categories()],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          displayInfo(
              'Asking Price', '₱ ${item.askingPrice.toStringAsFixed(2)}', true),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Item will be closed: ${item.formattedDT}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => displayBids())
        ],
      ),
    );
  }

  Widget displayInfo(String title, String content, [bool isPrice = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: robotoMedium.copyWith(
              color: blackColor,
              fontSize: 14,
            )),
        const SizedBox(
          height: 5,
        ),
        Text(
          content,
          style: isPrice
              ? robotoMedium.copyWith(color: orangeColor, fontSize: 25)
              : robotoRegular.copyWith(
                  color: greyColor,
                  fontSize: 14,
                ),
        )
      ],
    );
  }

  Widget displayBids() {
    if (isDoneLoading.value && itemList.isNotEmpty) {
      return ListView(
          padding: const EdgeInsets.all(25), shrinkWrap: true, children: []);
    } else if (isDoneLoading.value && itemList.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'No bids for this item at the moment'));
    }
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Chip> categories() {
    return item.category
        .map(
          (data) => Chip(
            backgroundColor: blackColor,
            label: Text(
              data,
              style: const TextStyle(color: whiteColor, fontSize: 13),
            ),
          ),
        )
        .toList();
  }
}
