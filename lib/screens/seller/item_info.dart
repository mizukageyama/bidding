import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/components/bid_tile.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class ItemInfoScreen extends StatelessWidget {
  const ItemInfoScreen({Key? key, required Item item})
      : _item = item,
        super(key: key);
  final Item _item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(
          _Content(
            item: _item,
          ),
          sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key, required this.item}) : super(key: key);

  final Item item;
  final BidsController bidsController = Get.put(BidsController());

  @override
  Widget build(BuildContext context) {
    bidsController.bindBidList(item.itemId);

    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          CategoryChip(
            items: item.category,
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(() => displayPrice()),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Item will be closed: ${item.formattedDT}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: displayBids(),
              ))
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

  Widget displayPrice() {
    if (bidsController.isDoneLoading.value && bidsController.bids.isNotEmpty) {
      int index = bidsController.approvedBid(bidsController.bids);
      if (index != -1) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            displayInfo(
              'Highest Approved Bid',
              '₱ ${bidsController.bids[index].ftAmount}',
              true,
            ),
            const SizedBox(
              width: 30,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const BidListScreen(),
                    transition: Transition.noTransition);
              },
              child: Text(
                'View Bids',
                style: robotoMedium.copyWith(
                    color: maroonColor,
                    decoration: TextDecoration.underline,
                    fontSize: 16),
              ),
            )
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          displayInfo(
            'Asking Price',
            '₱ ${item.ftAmount}',
            true,
          ),
          const SizedBox(
            width: 30,
          ),
          InkWell(
            onTap: () {
              Get.to(() => const BidListScreen(),
                  transition: Transition.noTransition);
            },
            child: Text(
              'View Bids',
              style: robotoMedium.copyWith(
                  color: maroonColor,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          )
        ],
      );
    } else if (bidsController.isDoneLoading.value &&
        bidsController.bids.isEmpty) {
      return displayInfo(
        'Asking Price',
        '₱ ${item.ftAmount}',
        true,
      );
    }
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(),
    );
  }

  Widget displayBids() {
    if (bidsController.isDoneLoading.value && bidsController.bids.isNotEmpty) {
      return SizedBox(
        width: Get.height * .65,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 45, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: neutralColor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bidsController.bids.length > 5
                    ? 5
                    : bidsController.bids.length,
                itemBuilder: (context, index) {
                  return BidTile(
                    bid: bidsController.bids[index],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: maroonColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              height: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Highest Bids',
                      style: robotoRegular.copyWith(color: whiteColor),
                    ),
                    Text(
                      'Status',
                      style: robotoRegular.copyWith(color: whiteColor),
                    ),
                  ]),
            ),
          ],
        ),
      );
    } else if (bidsController.isDoneLoading.value &&
        bidsController.bids.isEmpty) {
      return const InfoDisplay(message: 'No bids for this item at the moment');
    }
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(),
    );
  }
}
