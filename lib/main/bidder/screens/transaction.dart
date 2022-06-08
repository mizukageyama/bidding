import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/main/bidder/controllers/bought_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
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
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'My Transactions',
            body: _Content(),
          ),
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
      color: whiteColor,
      child: Column(
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
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
          Flexible(child: Obx(() => showTransactionList(context)))
        ],
      ),
    );
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
            boughtItems.filterDate();
          }
        },
        icon: const Icon(Icons.calendar_today),
        iconSize: 25,
      ),
    );
  }

  //transaction Data
  Widget showTransactionList(BuildContext context) {
    if (boughtItems.isDoneLoading.value && boughtItems.soldItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Successful Transactions...',
              style: robotoMedium.copyWith(
                  color: blackColor, fontSize: kIsWeb ? 16 : 16),
              textAlign: TextAlign.justify,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                'Date',
                style: robotoMedium.copyWith(
                    color: blackColor, fontSize: kIsWeb ? 16 : 16),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                child: getDate(context),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  width: 125,
                  height: 35,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Obx(
                      () => Text(boughtItems.date.value == ''
                          ? 'Select Date'
                          : boughtItems.date.value),
                    ),
                  )),
              IconButton(
                hoverColor: maroonColor,
                tooltip: 'refresh',
                onPressed: () {
                  boughtItems.refreshItem();
                },
                icon: const Icon(Icons.refresh),
                iconSize: 25,
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Container(
                height: Get.height,
                color: whiteColor,
                child: DataTableFormat(
                  columns: _createColumns(),
                  columnsMobile: _createColumnsMobile(),
                  rows: _createRows(context),
                  rowsMobile: _createRowsMobile(context),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (boughtItems.isDoneLoading.value &&
        boughtItems.soldItems.isEmpty) {
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
      const DataColumn(label: Text('Seller')),
      const DataColumn(label: Text('Date Sold')),
      const DataColumn(label: Text('Asking Price')),
      const DataColumn(label: Text('Bought At')),
      const DataColumn(label: Text('Action'))
    ];
  }

  List<DataRow> _createRows(BuildContext context) {
    return boughtItems.filtered.map((item) {
      return DataRow(cells: [
        DataCell(SizedBox(width: 200, child: Text(item.title))),
        DataCell(
          FutureBuilder(
            future: item.getSellerInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(item.sellerInfo!.fullName);
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
              //showTransactionInfo(context, item);
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
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createRowsMobile(BuildContext context) {
    return boughtItems.soldItems
        .map(
          (item) => DataRow(
            cells: [
              DataCell(SizedBox(width: 200, child: Text(item.title))),
              DataCell(Text(Format.dateShort(item.dateSold))),
              DataCell(
                InkWell(
                  onTap: () {
                    //  showTransactionInfo(context, item);
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
            ],
          ),
        )
        .toList();
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
                              'Seller',
                              style: robotoRegular.copyWith(
                                  color: blackColor, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.buyer?.fullName,
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
