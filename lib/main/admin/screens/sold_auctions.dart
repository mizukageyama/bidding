import 'package:bidding/components/_components.dart';
import 'package:bidding/components/for_forms/search_dropdown_field.dart';
import 'package:bidding/components/for_forms/search_text_field.dart';
import 'package:bidding/components/table_header_tile.dart';
import 'package:bidding/components/table_header_tile_mobile.dart';
import 'package:bidding/components/table_row_tile.dart';
import 'package:bidding/components/table_row_tile_mobile.dart';
import 'package:bidding/main/admin/controllers/sold_auction_controller.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/main/admin/screens/sold_view.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoldAuctionScreen extends StatelessWidget {
  const SoldAuctionScreen({Key? key}) : super(key: key);

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
  final SoldAuctionController _soldAuction = Get.find();

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
          ),
          Flexible(child: Obx(() => showTableReport(context)))
        ],
      ),
    );
  }

  Widget searchBar() {
    return Form(
      key: _soldAuction.formKey,
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
              onSaved: (value) => _soldAuction.titleKeyword.text = value!,
              controller: _soldAuction.titleKeyword,
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
              topLabel: 'Search by Seller',
              onSaved: (value) => _soldAuction.sellerKeyword.text = value!,
              controller: _soldAuction.sellerKeyword,
            ),
          ),
          const SizedBox(
            width: 10,
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
                    _soldAuction.sortOption.value = value!;
                    _soldAuction.sortItems();
                  },
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _soldAuction.sortOption.value != '',
                  child: IconButton(
                    onPressed: () {
                      _soldAuction.changeAscDesc();
                      _soldAuction.sortItems();
                    },
                    icon: Icon(
                      _soldAuction.asc.value
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
                          if (_soldAuction.hasInputKeywords) {
                            _soldAuction.filterItems();
                          }
                        },
                        text: 'Search',
                        buttonColor: maroonColor,
                        fontSize: 16,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _soldAuction.filterItems();
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
                      _soldAuction.refreshItem();
                    },
                    text: 'Refresh',
                    buttonColor: maroonColor,
                    fontSize: 16,
                  )
                : ElevatedButton(
                    onPressed: () {
                      _soldAuction.refreshItem();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: maroonColor, //maroonColor
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.refresh,
                        color: whiteColor,
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget showTableReport(BuildContext context) {
    if (_soldAuction.isDoneLoading.value &&
        _soldAuction.soldAuction.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            const SizedBox(
              height: 5,
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
                        itemCount: _soldAuction.filtered.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (kIsWeb && context.width >= 900) {
                            return row(_soldAuction.filtered[index], context);
                          }
                          return rowMobile(
                              _soldAuction.filtered[index], context);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _soldAuction.emptySearchResult,
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
    } else if (_soldAuction.isDoneLoading.value &&
        _soldAuction.soldAuction.isEmpty) {
      return const Center(child: InfoDisplay(message: 'No Sold items yet'));
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
        'Winning \nBid',
        'Winner',
      ],
    );
  }

  Widget rowMobile(SoldItem item, BuildContext context) {
    return TableRowTileMobile(rowData: [
      ImageView(
        imageUrl: item.images[0],
      ),
      InkWell(
        onTap: () => Get.to(() => SoldItemView(item: item)),
        child: Text(
          item.title,
          style: robotoMedium.copyWith(
            color: Colors.blue,
          ),
        ),
      ),
      Text(
        '₱ ${Format.amountShort(item.soldAt)}',
        style: robotoRegular.copyWith(
          color: blackColor,
        ),
      ),
      FutureBuilder(
        future: item.getBuyerInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              item.buyerName,
              style: robotoRegular.copyWith(
                color: blackColor,
              ),
            );
          }
          return const Text('     ');
        },
      ),
    ]);
  }

  Widget header() {
    return const TableHeaderTile(
      headerText: [
        'Item',
        'Date Sold',
        'Posted By',
        'Asking Price',
        'Winning Bid',
        'Winner',
        'Action',
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
        Text(Format.dateShort(item.dateSold)),
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
        Text('₱ ${Format.amount(item.soldAt)}'),
        FutureBuilder(
          future: item.getBuyerInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                item.buyerName,
                style: robotoRegular.copyWith(
                  color: blackColor,
                ),
              );
            }
            return const Text('     ');
          },
        ),
        InkWell(
          onTap: () => Get.to(() => SoldItemView(item: item)),
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
}
