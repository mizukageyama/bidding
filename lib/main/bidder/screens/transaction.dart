import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/controllers/bought_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

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
  final BoughtItemsController boughtItems = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xFFF5F5F5),
      child: Column(
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
                  'My Transactions',
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
          Flexible(child: Obx(() => showTransactionTable(context))),
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return Form(
      key: boughtItems.formKey,
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
              onSaved: (value) => boughtItems.titleKeyword.text = value!,
              controller: boughtItems.titleKeyword,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Search by Date Sold',
                  style: robotoMedium.copyWith(
                    color: greyColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: boughtItems.selectedDate.value,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2025),
                      );
                      if (selected != null) {
                        boughtItems.date.value =
                            DateFormat.yMMMd().format(selected);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(color: greyColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 25,
                              color: greyColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => Text(
                                boughtItems.date.value == ''
                                    ? 'Select Date'
                                    : boughtItems.date.value,
                                style: robotoRegular.copyWith(
                                    color: boughtItems.date.value == ''
                                        ? greyColor
                                        : blackColor),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  items: const ['Bought At', 'Date Sold', 'Item Title'],
                  onChanged: (value) {
                    boughtItems.sortOption.value = value!;
                    boughtItems.sortItems();
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: boughtItems.sortOption.value != '',
                  child: IconButton(
                    onPressed: () {
                      boughtItems.changeAscDesc();
                      boughtItems.sortItems();
                    },
                    icon: Icon(
                      boughtItems.asc.value
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
                          if (boughtItems.hasInputKeywords) {
                            boughtItems.filterItems();
                          }
                        },
                        text: 'Search',
                        buttonColor: maroonColor,
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          boughtItems.filterItems();
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
                          boughtItems.refreshItem();
                        },
                        text: 'Refresh',
                        buttonColor: maroonColor,
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          boughtItems.refreshItem();
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

  Widget showTransactionTable(BuildContext context) {
    if (boughtItems.isDoneLoading.value && boughtItems.soldItems.isNotEmpty) {
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
                      searchBar(context),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          itemCount: boughtItems.filtered.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future:
                                    boughtItems.filtered[index].getSellerInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kIsWeb && context.width >= 900) {
                                      return row(
                                          boughtItems.filtered[index], context);
                                    }
                                    return rowMobile(
                                        boughtItems.filtered[index], context);
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
                        visible: boughtItems.emptySearchResult,
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
    } else if (boughtItems.isDoneLoading.value &&
        boughtItems.soldItems.isEmpty) {
      return const Center(
          child: InfoDisplay(
              message: 'You dont have any item purchase to display.'));
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
        'Seller',
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
          onTap: () => showTransactionInfo(context, item),
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
        Text(item.sellerInfo?.fullName),
        Text(Format.dateShort(item.dateSold)),
        Text(Format.dateShort(item.datePosted)),
        Text('₱ ${Format.amountShort(item.askingPrice)}'),
        Text('₱ ${Format.amountShort(item.soldAt)}'),
        InkWell(
          onTap: () => showTransactionInfo(context, item),
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

  void showTransactionInfo(BuildContext context, SoldItem item) {
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
                  'Transaction Info',
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
                                'Seller',
                                style: robotoRegular.copyWith(
                                    color: blackColor, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.sellerInfo?.fullName,
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
              ]);
        });
  }

  //filter DateSold
  Widget getDate(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: () async {
          DateTime? selected = await showDatePicker(
            context: context,
            initialDate: boughtItems.selectedDate.value,
            firstDate: DateTime(2010),
            lastDate: DateTime(2025),
          );

          if (selected != null) {
            boughtItems.date.value = DateFormat.yMMMd().format(selected);
          }
        },
        icon: const Icon(Icons.calendar_today),
        iconSize: 25,
      ),
    );
  }
}
