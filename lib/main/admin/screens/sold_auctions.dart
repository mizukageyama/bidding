import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/main/admin/controllers/sold_auction_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/layout/test_side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoldAuctionScreen extends StatelessWidget {
  const SoldAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TestSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Sold Auctions',
            body: _Content(),
          ),
          TestSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final _horizontalScrollController = ScrollController();
  final SoldAuctionController _soldAuction = Get.put(SoldAuctionController());

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
                        'Sold Auctions',
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
          Flexible(child: Obx(() => showTableReport()))
        ],
      ),
    );
  }

  Widget showTableReport() {
    if (_soldAuction.isDoneLoading.value &&
        _soldAuction.soldAuction.isNotEmpty) {
      return Scrollbar(
        controller: _horizontalScrollController,
        isAlwaysShown: true,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 25, horizontal: kIsWeb ? 10 : 3),
              child: Container(
                  height: Get.height,
                  color: whiteColor,
                  child: DataTableFormat(
                    columns: _createColumns(),
                    columnsMobile: _createColumnsMobile(),
                    rows: _createRows(),
                    rowsMobile: _createRowsMobile(),
                  )),
            )),
      );
    } else if (_soldAuction.isDoneLoading.value &&
        _soldAuction.soldAuction.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'No ongoing auction at the moment'));
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
      const DataColumn(label: Text('Date Sold')),
      const DataColumn(label: Text('Posted By')),
      const DataColumn(label: Text('Asking Price')),
      const DataColumn(label: Text('Winning Bid')),
      const DataColumn(label: Text('Winner Name')),
      const DataColumn(label: Text('Action'))
    ];
  }

  List<DataRow> _createRows() {
    return _soldAuction.soldAuction.map((item) {
      return DataRow(cells: [
        DataCell(SizedBox(width: 200, child: Text(item.title))),
        DataCell(Text(Format.dateShort(item.dateSold))),
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
        DataCell(Text('₱ ${Format.amount(item.askingPrice)}')),
        DataCell(Text('₱ ${Format.amount(item.soldAt)}')),
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
        DataCell(
          InkWell(
            onTap: () {},
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

  //Data Mobile
  List<DataColumn> _createColumnsMobile() {
    return [
      const DataColumn(label: SizedBox(width: 190, child: Text('Item'))),
      const DataColumn(label: Text(kIsWeb ? 'Winning Bid' : 'Winning\n Bid')),
      const DataColumn(label: Text(kIsWeb ? 'Winner Name' : 'Winner\n Name')),
    ];
  }

  List<DataRow> _createRowsMobile() {
    return _soldAuction.soldAuction
        .map(
          (item) => DataRow(
            cells: [
              DataCell(
                InkWell(
                  onTap: () {},
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
              DataCell(
                Text(
                  '₱ ${Format.amountShort(item.soldAt)}',
                  style: robotoRegular.copyWith(
                    color: blackColor,
                  ),
                ),
              ),
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
            ],
          ),
        )
        .toList();
  }
}
