import 'package:bidding/components/_components.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/components/for_forms/search_dropdown_field.dart';
import 'package:bidding/components/for_forms/search_text_field.dart';
import 'package:bidding/components/pdf_generate_invoice.dart';
import 'package:bidding/components/pdf_open.dart';
import 'package:bidding/components/table_header_tile.dart';
import 'package:bidding/components/table_header_tile_mobile.dart';
import 'package:bidding/components/table_row_tile.dart';
import 'package:bidding/components/table_row_tile_mobile.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/_models.dart';

class SoldItemList extends StatelessWidget {
  const SoldItemList({Key? key}) : super(key: key);

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
  final SoldItemsController soldItemsController = Get.find();
  final BidsController bidsController = Get.put(BidsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: maroonColor,
            height: 50,
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
          ),
          Flexible(child: Obx(() => showSoldItems(context))),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Form(
      key: soldItemsController.formKey,
      child: Wrap(
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: kIsWeb
                ? Get.width >= 600 && Get.width < 900
                    ? 200
                    : 250
                : Get.width / 2,
            child: SearchTextField(
              topLabel: 'Search by Title',
              onSaved: (value) =>
                  soldItemsController.titleKeyword.text = value!,
              controller: soldItemsController.titleKeyword,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: kIsWeb
                ? Get.width >= 600 && Get.width < 900
                    ? 200
                    : 250
                : Get.width / 2,
            child: SearchTextField(
              topLabel: 'Search by Winner',
              onSaved: (value) =>
                  soldItemsController.winnerKeyword.text = value!,
              controller: soldItemsController.winnerKeyword,
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
                  items: const ['Item Title', 'Date Sold'],
                  onChanged: (value) {
                    soldItemsController.sortOption.value = value!;
                    soldItemsController.sortItems();
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: soldItemsController.sortOption.value != '',
                  child: IconButton(
                    onPressed: () {
                      soldItemsController.changeAscDesc();
                      soldItemsController.sortItems();
                    },
                    icon: Icon(
                      soldItemsController.asc.value
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
                          if (soldItemsController.hasInputKeywords) {
                            soldItemsController.filterItems();
                          }
                        },
                        text: 'Search',
                        buttonColor: maroonColor,
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          soldItemsController.filterItems();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: maroonColor, //maroonColor
                        ),
                        child: const Icon(
                          Icons.search,
                          color: whiteColor,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 45,
            child: kIsWeb && Get.width >= 600
                ? CustomButton(
                    onTap: () {
                      soldItemsController.refreshItem();
                    },
                    text: 'Refresh',
                    buttonColor: maroonColor, //maroonColor
                    fontSize: 16,
                  )
                : ElevatedButton(
                    onPressed: () {
                      soldItemsController.refreshItem();
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
    );
  }

  Future<void> getInfo(SoldItem item) async {
    await item.getBuyerInfo();
    await item.getSellerInfo();
  }

  Widget showSoldItems(BuildContext context) {
    if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Container(
                height: Get.height,
                color: whiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: kIsWeb && context.width >= 900
                          ? header()
                          : headerMobile(),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: soldItemsController.filtered.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future:
                                  getInfo(soldItemsController.filtered[index]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (kIsWeb && context.width >= 900) {
                                    return row(
                                      soldItemsController.filtered[index],
                                      context,
                                    );
                                  }
                                  return rowMobile(
                                    soldItemsController.filtered[index],
                                    context,
                                  );
                                }
                                return const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                              });
                        },
                      ),
                    ),
                    Visibility(
                      visible: soldItemsController.emptySearchResult,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                        child: NoDisplaySearchResult(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'You have no Sold items yet.'));
    }
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget headerMobile() {
    return const TableHeaderTileMobile(
      headerText: [
        'Item',
        'Date Sold',
        'Bought At',
      ],
    );
  }

  Widget header() {
    return const TableHeaderTile(
      headerText: [
        'Item',
        'Buyer',
        'Date Sold',
        'Date Posted',
        'Asking Price',
        'Bought At',
        'Action',
      ],
    );
  }

  Widget rowMobile(SoldItem item, BuildContext context) {
    return TableRowTileMobile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
          isContained: false,
        ),
        InkWell(
          onTap: () => showSoldItemInfo(context, item),
          child: Text(
            item.title,
            style: robotoMedium.copyWith(
              color: Colors.blue,
            ),
          ),
        ),
        Text(Format.dateShort(item.dateSold)),
        Text('₱ ${Format.amountShort(item.soldAt)}'),
      ],
    );
  }

  Widget row(SoldItem item, BuildContext context) {
    return TableRowTile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
          isContained: false,
        ),
        Text(item.title),
        Text(item.buyerName),
        Text(Format.dateShort(item.dateSold)),
        Text(Format.dateShort(item.datePosted)),
        Text('₱ ${Format.amountShort(item.askingPrice)}'),
        Text('₱ ${Format.amountShort(item.soldAt)}'),
        InkWell(
          onTap: () => showSoldItemInfo(
            context,
            item,
          ),
          child: Text(
            'View',
            style: robotoMedium.copyWith(
              color: maroonColor,
            ),
          ),
        ),
      ],
    );
  }

  void showSoldItemInfo(BuildContext context, SoldItem item) {
    showDialog(
        context: context,
        builder: (context) {
          bidsController.bindBidList(item.itemId);
          return SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: kIsWeb && Get.width >= 600 ? 50 : 30,
              ),
              children: [
                Text(
                  'Sold Item Info',
                  style: robotoMedium.copyWith(color: blackColor, fontSize: 18),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageView(
                      width: 90,
                      height: 90,
                      imageUrl: item.images[0],
                      isContained: false,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item #',
                                style: robotoRegular.copyWith(
                                    color: blackColor, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.itemId,
                                style: robotoRegular.copyWith(
                                    color: greyColor,
                                    fontSize: kIsWeb ? 13 : 11.5),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Buyer',
                                style: robotoRegular.copyWith(
                                    color: blackColor, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.buyerName,
                                style: robotoRegular.copyWith(
                                    color: greyColor, fontSize: 13),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  item.title,
                  style: robotoBold.copyWith(
                    color: maroonColor,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 520,
                  child: Text(
                    item.description,
                    style:
                        robotoRegular.copyWith(color: greyColor, fontSize: 15),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CategoryChip(
                  items: item.category,
                ),
                const SizedBox(
                  height: 15,
                ),
                DisplayInfo(
                  title: 'Asking Price',
                  content: '₱ ${Format.amount(item.askingPrice)}',
                ),
                const SizedBox(
                  height: 10,
                ),
                DisplayInfo(
                  title: 'Bought At',
                  content: '₱ ${Format.amount(item.soldAt)}',
                  isPrice: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Wrap(
                  runSpacing: 5,
                  children: [
                    Text(
                      'Posted:',
                      style: robotoRegular.copyWith(color: greyColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      Format.date(item.datePosted),
                      style: robotoRegular.copyWith(color: greyColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  runSpacing: 5,
                  children: [
                    Text(
                      'Closed:',
                      style: robotoRegular.copyWith(color: greyColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      Format.date(item.endDate),
                      style: robotoRegular.copyWith(color: greyColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  runSpacing: 5,
                  children: [
                    Text(
                      'Mark as Sold:',
                      style: robotoRegular.copyWith(color: greyColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      Format.date(item.dateSold),
                      style: robotoRegular.copyWith(color: greyColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final pdfFile =
                          await PdfInvoice.generate(bidsController.bids, item);
                      PdfApi.openFile(pdfFile);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: maroonColor,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            color: whiteColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Generate Invoice',
                            textAlign: TextAlign.center,
                          ),
                        ])),
              ]);
        });
  }
}
