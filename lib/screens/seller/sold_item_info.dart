import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/category_chip.dart';
import 'package:bidding/shared/components/display_info_section.dart';
import 'package:bidding/shared/components/gallery_view.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/seller_side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/material.dart';

class SoldItemInfoScreen extends StatelessWidget {
  const SoldItemInfoScreen({Key? key, required SoldItem item})
      : _item = item,
        super(key: key);
  final SoldItem _item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(
          _Content(
            item: _item,
          ),
          SellerSideMenu()),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.item}) : super(key: key);
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
            height: 20,
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: item.getBuyerInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return DisplayInfo(
                    title: 'Auction Winner', content: item.buyerName);
              }
              return const SizedBox(
                height: 0,
                width: 0,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Wrap(
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DisplayInfo(
                  title: 'Asking Price',
                  content: '₱ ${Format.amount(item.askingPrice)}',
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      content: '₱ ${Format.amount(item.soldAt)}',
                      isPrice: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Closed: ${Format.date(item.endDate)}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Marked as Sold: ${Format.date(item.dateSold)}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
        ],
      ),
    );
  }
}
