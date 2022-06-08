import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/main/admin/controllers/open_auction_controller.dart';
import 'package:bidding/main/admin/screens/open_closed_view.dart';
import 'package:bidding/main/admin/screens/side_menu.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpenAuctionScreen extends StatelessWidget {
  const OpenAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AdminSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Open Auctions',
            body: _Content(),
          ),
          AdminSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final OpenAuctionController _openAuction = Get.find();

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
                        'Open Auctions',
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
          child: Form(
            key: _openAuction.formKey,
            child: InputField(
              hideLabelTyping: true,
              labelText: 'Search here...',
              onChanged: (value) {
                return;
              },
              onSaved: (value) => _openAuction.titleKeyword.text = value!,
              controller: _openAuction.titleKeyword,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: kIsWeb ? 110 : 50,
          height: 50,
          child: kIsWeb
              ? CustomButton(
                  onTap: () {
                    _openAuction.filterItems();
                  },
                  text: 'Search',
                  buttonColor: maroonColor,
                  fontSize: 16,
                )
              : ElevatedButton(
                  onPressed: () {
                    _openAuction.filterItems();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: maroonColor, //maroonColor
                  ),
                  child: const Icon(
                    Icons.search,
                    color: whiteColor,
                    size: 25,
                  ),
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: kIsWeb ? 110 : 50,
          height: 45,
          child: kIsWeb
              ? CustomButton(
                  onTap: () {
                    _openAuction.refreshItem();
                  },
                  text: 'Refresh',
                  buttonColor: maroonColor, //maroonColor
                  fontSize: 16,
                )
              : ElevatedButton(
                  onPressed: () {
                    _openAuction.refreshItem();
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

  Widget showTableReport() {
    if (_openAuction.isDoneLoading.value && _openAuction.openItems.isNotEmpty) {
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
                color: whiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DataTableFormat(
                      columns: _createColumns(),
                      columnsMobile: _createColumnsMobile(),
                      rows: _createRows(),
                      rowsMobile: _createRowsMobile(),
                    ),
                    Visibility(
                      visible: _openAuction.emptySearchResult,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        child: Text(
                            _openAuction.emptySearchResultSearchResultMessage),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_openAuction.isDoneLoading.value &&
        _openAuction.openItems.isEmpty) {
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
      const DataColumn(label: Text('Date Posted')),
      const DataColumn(label: Text('Closing Date')),
      const DataColumn(label: Text('Posted By')),
      const DataColumn(label: Text('Asking Price')),
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
    return _openAuction.filtered.map((item) {
      return DataRow(cells: [
        DataCell(SizedBox(width: 200, child: Text(item.title))),
        DataCell(Text(Format.dateShort(item.datePosted))),
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
      const DataColumn(label: Text(kIsWeb ? 'Asking Price' : 'Asking\nPrice')),
      const DataColumn(
        label: Text(kIsWeb ? 'Highest Bid' : 'Highest\nBid'),
        tooltip: 'Current Highest Approved Bid',
      ),
    ];
  }

  List<DataRow> _createRowsMobile() {
    return _openAuction.filtered
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
