import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/auctioned_items_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemInfoScreen extends StatelessWidget {
  const ItemInfoScreen({Key? key, required Item item, required this.id})
      : _item = item,
        super(key: key);
  final Item _item;
  final String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: ResponsiveView(
          _Content(item: _item, id: id),
          SellerSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({
    Key? key,
    required this.item,
    required this.id,
  }) : super(key: key);
  Item item;
  final String id;
  final BidsController bidsController = Get.put(BidsController());
  final AuctionedItemController aController = Get.find();

  Item getItem() {
    item = aController.itemList
        .firstWhere((val) => val.itemId == item.itemId, orElse: () => item);
    return item;
  }

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
                Flexible(
                  child: Text(
                    'Auctioned Items > ${item.title}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: whiteColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          kIsWeb && Get.width >= 600
              ? Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LeftColumn(
                              images: item.images,
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => RightColumn(
                                  item: getItem(),
                                  controller: bidsController,
                                  isBidder: false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      LeftColumn(
                        images: item.images,
                      ),
                      Obx(
                        () => RightColumn(
                            item: getItem(),
                            controller: bidsController,
                            isBidder: false),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
