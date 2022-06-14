import 'package:bidding/components/_components.dart';
import 'package:bidding/components/search_dropdown_field.dart';
import 'package:bidding/components/search_text_field.dart';
import 'package:bidding/components/table_header_tile.dart';
import 'package:bidding/components/table_header_tile_mobile.dart';
import 'package:bidding/components/table_row_tile.dart';
import 'package:bidding/components/table_row_tile_mobile.dart';
import 'package:bidding/main/admin/controllers/open_auction_controller.dart';
import 'package:bidding/main/admin/screens/open_closed_view.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpenAuctionScreen extends StatelessWidget {
  const OpenAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: AdminSideMenu(),
        body: ResponsiveView(
          _Content(),
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
          ),
          Flexible(child: Obx(() => showTableReport(context)))
        ],
      ),
    );
  }

  Widget searchBar() {
    return Form(
      key: _openAuction.formKey,
      child: Wrap(
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: Get.width >= 600 && Get.width < 900 ? 200 : 250,
            child: SearchTextField(
              topLabel: 'Search by Title',
              onSaved: (value) => _openAuction.titleKeyword.text = value!,
              controller: _openAuction.titleKeyword,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: Get.width >= 600 && Get.width < 900 ? 200 : 250,
            child: SearchTextField(
              topLabel: 'Search by Seller',
              onSaved: (value) => _openAuction.sellerKeyword.text = value!,
              controller: _openAuction.sellerKeyword,
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
                width: Get.width >= 600 && Get.width < 900 ? 200 : 250,
                child: SearchDropdownField(
                  topLabel: 'Sort by',
                  items: const ['Asking Price', 'Closing Date', 'Item Title'],
                  onChanged: (value) {
                    _openAuction.sortOption.value = value!;
                    _openAuction.sortItems();
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _openAuction.sortOption.value != '',
                  child: IconButton(
                    onPressed: () {
                      _openAuction.changeAscDesc();
                      _openAuction.sortItems();
                    },
                    icon: Icon(
                      _openAuction.asc.value
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
                          if (_openAuction.hasInputKeywords) {
                            _openAuction.filterItems();
                          }
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

  Widget showTableReport(BuildContext context) {
    if (_openAuction.isDoneLoading.value && _openAuction.openItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            const SizedBox(
              height: 24,
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
                        itemCount: _openAuction.filtered.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (kIsWeb && context.width >= 900) {
                            return row(_openAuction.filtered[index], context);
                          }
                          return rowMobile(
                              _openAuction.filtered[index], context);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _openAuction.emptySearchResult,
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

  Widget headerMobile() {
    return const TableHeaderTileMobile(
      headerText: [
        'Item',
        'Asking Price',
        'Highest Bid',
      ],
    );
  }

  Widget rowMobile(Item item, BuildContext context) {
    return TableRowTileMobile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
        ),
        InkWell(
          onTap: () => Get.to(() => OpenClosedItemView(item: item)),
          child: Text(
            item.title,
            style: robotoMedium.copyWith(
              color: Colors.blue,
            ),
          ),
        ),
        Text('₱ ${Format.amount(item.askingPrice)}'),
        FutureBuilder(
          future: item.getBids(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (item.bids.isEmpty) {
                return const Text(
                  '---',
                );
              }
              return Text('₱ ${Format.amount(item.bids[0].amount)}');
            }
            return const Text('     ');
          },
        ),
      ],
    );
  }

  Widget header() {
    return const TableHeaderTile(
      headerText: [
        'Item',
        'Date Posted',
        'Closing Date',
        'Posted By',
        'Asking Price',
        'Highest Bid',
        'Action',
      ],
    );
  }

  Widget row(Item item, BuildContext context) {
    return TableRowTile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
        ),
        Text(item.title),
        Text(Format.dateln(item.datePosted)),
        Text(Format.dateln(item.endDate)),
        FutureBuilder(
          future: item.getSellerInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(item.sellerInfo!.fullName);
            }
            return const Text('     ');
          },
        ),
        Text('₱ ${Format.amount(item.askingPrice)}'),
        FutureBuilder(
          future: item.getBids(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (item.bids.isEmpty) {
                return const Text(
                  '---',
                );
              }
              return Text('₱ ${Format.amount(item.bids[0].amount)}');
            }
            return const Text('     ');
          },
        ),
        InkWell(
          onTap: () => Get.to(() => OpenClosedItemView(item: item)),
          child: Text(
            'View',
            style: robotoMedium.copyWith(
              color: maroonColor,
            ),
          ),
        )
      ],
    );
  }
}
