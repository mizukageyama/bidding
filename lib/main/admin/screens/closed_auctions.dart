import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/main/admin/controllers/closed_auction_controller.dart';
import 'package:bidding/main/admin/screens/open_closed_view.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/layout/test_side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClosedAuctionScreen extends StatelessWidget {
  const ClosedAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TestSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Closed Auctions',
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
  final ClosedAuctionController _closedAuction =
      Get.put(ClosedAuctionController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xFFF5F5F5),
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
                        'Closed Auctions',
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

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 45,
            child: InputField(
              labelText: 'Search here...',
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                return;
              },
              onSaved: (value) => {},
              controller: TextEditingController(),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 110,
          height: 45,
          child: CustomButton(
            onTap: () {},
            text: 'Search',
            buttonColor: maroonColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget showTableReport() {
    if (_closedAuction.isDoneLoading.value &&
        _closedAuction.closedItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 3),
        child: Column(
          children: [
            searchBar(),
            const SizedBox(
              height: 24,
            ),
            Flexible(
              child: Container(
                height: Get.height,
                color: whiteColor,
                child: DataTableFormat(
                  columns: _createColumns(),
                  columnsMobile: _createColumnsMobile(),
                  rows: _createRows(),
                  rowsMobile: _createRowsMobile(),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_closedAuction.isDoneLoading.value &&
        _closedAuction.closedItems.isEmpty) {
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
      const DataColumn(label: Text('Date Closed')),
      const DataColumn(label: Text('Posted By')),
      const DataColumn(label: Text('Asking Price')),
      const DataColumn(label: Text('Status')),
      const DataColumn(
        label: Text(
          'Highest Bid',
        ),
        tooltip: 'Current Highest Approved Bid',
      ),
      const DataColumn(label: Text('Action'))
    ];
  }

  List<DataRow> _createRows() {
    return _closedAuction.closedItems.map((item) {
      return DataRow(cells: [
        DataCell(SizedBox(width: 200, child: Text(item.title))),
        DataCell(Text(Format.dateShort(item.endDate))),
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
        DataCell(
          item.winningBid == ''
              ? Container(
                  height: 25,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2), color: greyColor),
                  child: Text(
                    'To Select',
                    style: robotoRegular.copyWith(color: whiteColor),
                  ),
                  alignment: Alignment.center,
                )
              : Container(
                  height: 25,
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: greenColor),
                  child: Text(
                    'Winner Selected',
                    style: robotoRegular.copyWith(color: whiteColor),
                  ),
                  alignment: Alignment.center,
                ),
        ),
        DataCell(
          FutureBuilder(
            future: item.getBids(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (item.bids.isEmpty) {
                  return const Center(
                    child: Text(
                      '---',
                    ),
                  );
                }
                return Text('₱ ${Format.amount(item.bids[0].amount)}');
              }
              return const Text('     ');
            },
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              Get.to(() => OpenClosedItemView(item: item));
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

  //Data Mobile
  List<DataColumn> _createColumnsMobile() {
    return [
      const DataColumn(label: SizedBox(width: 190, child: Text('Item'))),
      const DataColumn(label: Text(kIsWeb ? 'Asking Price' : 'Asking\n Price')),
      const DataColumn(
        label: Text(kIsWeb ? 'Highest Bid' : 'Highest\nBid'),
        tooltip: 'Current Highest Approved Bid',
      ),
    ];
  }

  List<DataRow> _createRowsMobile() {
    return _closedAuction.closedItems
        .map(
          (item) => DataRow(
            cells: [
              DataCell(
                InkWell(
                  onTap: () {
                    Get.to(() => OpenClosedItemView(item: item));
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
              DataCell(
                Text(
                  '₱ ${Format.amountShort(item.askingPrice)}',
                  style: robotoRegular.copyWith(
                    color: blackColor,
                  ),
                ),
              ),
              DataCell(
                FutureBuilder(
                  future: item.getBids(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (item.bids.isEmpty) {
                        return Center(
                          child: Text(
                            '---',
                            style: robotoRegular.copyWith(
                              color: blackColor,
                            ),
                          ),
                        );
                      }
                      return Text(
                        '₱ ${Format.amountShort(item.bids[0].amount)}',
                        style: robotoRegular.copyWith(
                          color: blackColor,
                        ),
                      );
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
