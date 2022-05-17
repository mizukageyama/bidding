import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/category_chip.dart';
import 'package:bidding/shared/components/display_info_section.dart';
import 'package:bidding/shared/components/gallery_view.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SoldItemInfoScreen extends StatelessWidget {
  const SoldItemInfoScreen({Key? key, required SoldItem item})
      : _item = item,
        super(key: key);
  final SoldItem _item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(item: _item), sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.item}) : super(key: key);
  //TO DO: show the bidder who won
  final SoldItem item;

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
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: Get.width,
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
                Text(
                  'Sold Item > ${item.title}',
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
          Expanded(
            child: ListView(
              shrinkWrap: true,
              primary: true,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: leftColumn()),
                    Expanded(child: rightColumn()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leftColumn() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GalleryView(
        images: item.images,
      ),
    );
  }

  Widget rightColumn() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          DisplayInfo(title: 'Description', content: item.description),
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
                    DisplayInfo(title: 'Brand', content: item.brand),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          CategoryChip(
            items: item.category,
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DisplayInfo(
                  title: 'Asking Price',
                  content: '₱ ${item.ftAmount}',
                ),
                const SizedBox(
                  width: 15,
                ),
                const Icon(
                  Icons.arrow_forward_outlined,
                  color: greyColor,
                  size: 20,
                ),
                const SizedBox(
                  width: 15,
                ),
                DisplayInfo(
                  title: 'Sold at',
                  content: '₱ ${item.ftSoldAmount}',
                  isPrice: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Item was closed: ${item.formattedDT}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
        ],
      ),
    );
  }
}
