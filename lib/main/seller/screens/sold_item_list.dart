import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/services/dialogs.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:bidding/shared/services/pdf_open.dart';
import 'package:bidding/shared/services/pdf_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      width: context.width,
      height: context.height,
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
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 25, horizontal: kIsWeb ? 25 : 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandablePanel(
                  header: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: fadeColor,
                      border: Border.all(color: neutralColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: brownColor,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Filter Item',
                          style: robotoMedium.copyWith(
                              fontSize: 17, color: brownColor),
                        ),
                      ],
                    ),
                  ),
                  collapsed: const SizedBox(
                    height: 20,
                    width: 0,
                  ),
                  expanded: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      searchBar(),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
                Container(
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 20,
                          maxHeight: 500,
                        ),
                        child: ListView.builder(
                          itemCount: soldItemsController.filtered.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: getInfo(
                                    soldItemsController.filtered[index]),
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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                          child: NoDisplaySearchResult(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
        child: CircularProgressIndicator(
          color: maroonColor,
        ),
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
    bidsController.bindBidList(item.itemId);
    showDialog(
        context: context,
        builder: (context) {
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
                    showLoading();
                    try {
                      if (kIsWeb) {
                        await PdfService.generateWeb(
                            item: item, bids: bidsController.bids);
                        dismissDialog();
                      } else {
                        final pdfFile = await PdfService.generate(
                          item: item,
                          bids: bidsController.bids,
                        );
                        dismissDialog();
                        PdfApi.openFile(pdfFile);
                      }
                    } catch (error) {
                      dismissDialog();
                      showErrorDialog(
                        errorTitle: 'Something went wrong',
                        errorDescription: 'Please try again later',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: maroonColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          color: whiteColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Generate Report',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
        });
  }
}
