import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoldItemList extends StatelessWidget {
  const SoldItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SellerSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Sold Items',
            body: _Content(),
          ),
          SellerSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final SoldItemsController soldItemsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: whiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kIsWeb && Get.width >= 600
              ? Container(
                  color: maroonColor,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
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
                )
              : const SizedBox(
                  height: 0,
                ),
          Flexible(child: Obx(() => showSoldItems(context))),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Form(
            key: soldItemsController.formKey,
            child: InputField(
              hideLabelTyping: true,
              labelText: 'Search here...',
              onChanged: (value) {
                return;
              },
              onSaved: (value) =>
                  soldItemsController.titleKeyword.text = value!,
              controller: soldItemsController.titleKeyword,
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
                    soldItemsController.filterItems();
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
                    primary: greyColor,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: whiteColor,
                  ),
                ),
        ),
      ],
    );
  }

  //Sold DataTable
  Widget showSoldItems(BuildContext context) {
    if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Your Sold Items...',
            //   style: robotoMedium.copyWith(
            //       color: blackColor, fontSize: kIsWeb ? 16 : 16),
            //   textAlign: TextAlign.justify,
            // ),
            // const SizedBox(
            //   height: 24,
            // ),
            searchBar(),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Container(
                  height: Get.height,
                  color: whiteColor,
                  child: Column(
                    children: [
                      DataTableFormat(
                        columns: _createColumns(),
                        columnsMobile: _createColumnsMobile(),
                        rows: _createRows(context),
                        rowsMobile: _createRowsMobile(context),
                      ),
                      soldItemsController.emptySearchResult
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 10, right: 10),
                              child: NoDisplaySearchResult(
                                content: 'No item found with ',
                                title: '"${soldItemsController.searchKey}"',
                                message: ' in title',
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  )),
            ),
          ],
        ),
      );
    } else if (soldItemsController.isDoneLoading.value &&
        soldItemsController.soldItems.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'No ongoing auctions at the moment.'));
    }
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Item')),
      const DataColumn(label: Text('Buyer')),
      const DataColumn(label: Text('Date Sold')),
      const DataColumn(label: Text('Asking Price')),
      const DataColumn(label: Text('Bought At')),
      const DataColumn(label: Text('Action'))
    ];
  }

  List<DataRow> _createRows(BuildContext context) {
    return soldItemsController.filtered.map((item) {
      return DataRow(cells: [
        DataCell(SizedBox(width: 200, child: Text(item.title))),
        DataCell(
          FutureBuilder(
            future: item.getBuyerInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(item.buyerName);
              }
              return const Text('     ');
            },
          ),
        ),
        DataCell(Text(Format.dateShort(item.dateSold))),
        DataCell(Text('₱ ${Format.amount(item.askingPrice)}')),
        DataCell(Text('₱ ${Format.amount(item.soldAt)}')),
        DataCell(
          InkWell(
            onTap: () {
              showSoldItemInfo(context, item);
            },
            child: Text(
              'View',
              style: robotoMedium.copyWith(
                color: maroonColor,
              ),
            ),
          ),
        ),
      ]);
    }).toList();
  }

//Mobile Version
  List<DataColumn> _createColumnsMobile() {
    return [
      const DataColumn(label: SizedBox(width: 190, child: Text('Item'))),
      const DataColumn(label: Text(kIsWeb ? 'Date Sold' : 'Date\nSold')),
      const DataColumn(label: Text('Bought At')),
    ];
  }

  List<DataRow> _createRowsMobile(BuildContext context) {
    return soldItemsController.filtered
        .map(
          (item) => DataRow(
            cells: [
              DataCell(
                InkWell(
                  onTap: () {
                    showSoldItemInfo(context, item);
                  },
                  child: SizedBox(
                    width: 190,
                    child: Text(
                      item.title,
                      style: robotoMedium.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(Text(
                Format.dateShort(item.dateSold),
                style: robotoRegular.copyWith(
                  color: blackColor,
                ),
              )),
              DataCell(
                Text(
                  '₱ ${Format.amountShort(item.soldAt)}',
                  style: robotoRegular.copyWith(
                    color: blackColor,
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  //Sold Item info
  void showSoldItemInfo(BuildContext context, SoldItem item) {
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
                      isContained: false,
                    ),
                    Padding(
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
}
