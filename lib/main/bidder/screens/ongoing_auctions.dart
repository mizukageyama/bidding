import 'package:bidding/components/_components.dart';
import 'package:bidding/components/for_forms/multi_select_dropdown.dart';
import 'package:bidding/components/for_forms/search_dropdown_field.dart';
import 'package:bidding/components/for_forms/search_text_field.dart';
import 'package:bidding/main/bidder/controllers/ongoing_auction_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OngoingAuctionScreen extends StatelessWidget {
  const OngoingAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
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
      height: context.height,
      width: context.width,
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  visible: context.width < 600,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              kIsWeb ? 20 : 12,
              20,
              kIsWeb ? 20 : 12,
              kIsWeb ? 0 : 5,
            ),
            child: searchBar(context),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(child: Obx(() => showItems())),
        ],
      ),
    );
  }

  Widget showItems() {
    if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isNotEmpty) {
      if (itemListController.emptySearchResult) {
        return const Center(
          child: NoDisplaySearchResult(),
        );
      }
      return ListView(
          padding: const EdgeInsets.all(kIsWeb ? 25 : 12),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            ResponsiveItemGrid(
              item: itemListController.filtered,
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

  Widget searchBar(BuildContext context) {
    return Form(
      key: itemListController.formKey,
      child: Wrap(
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: context.width >= 600 && context.width < 900 ? 200 : 250,
            child: SearchTextField(
              topLabel: 'Search by Title',
              onSaved: (value) => itemListController.titleKeyword.text = value!,
              controller: itemListController.titleKeyword,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: context.width >= 600 && context.width < 900 ? 200 : 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search by Category',
                  style: robotoMedium.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width:
                      context.width >= 600 && context.width < 900 ? 200 : 250,
                  child: Obx(
                    () => MultiSelectDropdown(
                      selectedItems: List<String>.from(
                          itemListController.categoryKeyWords),
                      items: categorySearchOption,
                      onChanged: (value, selected) {
                        if (selected) {
                          itemListController.categoryKeyWords.remove(value);
                        } else {
                          itemListController.categoryKeyWords.add(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: kIsWeb
                    ? Get.width >= 600 && Get.width < 900
                        ? 200
                        : 250
                    : Get.width / 2,
                child: SearchDropdownField(
                  topLabel: 'Sort by',
                  items: const ['Closing Date', 'Item Title', 'Price'],
                  onChanged: (value) {
                    itemListController.sortOption.value = value!;
                    itemListController.sortItems();
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: itemListController.sortOption.value != '',
                  child: IconButton(
                    onPressed: () {
                      itemListController.changeAscDesc();
                      itemListController.sortItems();
                    },
                    icon: Icon(
                      itemListController.asc.value
                          ? Icons.south_outlined
                          : Icons.north_outlined,
                      color: greyColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 45,
                child: kIsWeb && Get.width >= 600
                    ? CustomButton(
                        onTap: () {
                          if (itemListController.hasInputKeywords) {
                            itemListController.filterItems();
                          }
                        },
                        text: 'Search',
                        buttonColor: maroonColor,
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          itemListController.filterItems();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: maroonColor,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: whiteColor,
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 45,
                child: kIsWeb && Get.width >= 600
                    ? CustomButton(
                        onTap: () {
                          itemListController.refreshItem();
                        },
                        text: 'Refresh',
                        buttonColor: maroonColor, //maroonColor
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          itemListController.refreshItem();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: maroonColor,
                        ),
                        child: const Icon(
                          Icons.refresh,
                          color: whiteColor,
                        ),
                      ),
              ),
            ],
          ),
        ],
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
      perColumn: 2, item: item, isSoldItem: false, oneRow: false);

  @override
  Widget? tablet() => ItemLayoutGrid(
      perColumn: 3, item: item, isSoldItem: false, oneRow: false);

  @override
  Widget? desktop() => ItemLayoutGrid(
      perColumn: 4, item: item, isSoldItem: false, oneRow: false);
}
