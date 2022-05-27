import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/controllers/bought_items_controller.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  final BoughtItemsController boughtItemsController = Get.find();

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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(kIsWeb ? 30 : 15),
              shrinkWrap: true,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your successful transactions for the past weeks.',
                          style: robotoMedium.copyWith(
                              color: blackColor, fontSize: kIsWeb ? 16 : 16),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Date',
                              style: robotoMedium.copyWith(
                                  color: blackColor,
                                  fontSize: kIsWeb ? 16 : 16),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                width: 120,
                                height: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: blackColor,
                                    size: 25,
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: Get.height * .7,
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kIsWeb ? header() : phoneHeaderVersion(),
                                Flexible(
                                  child: Obx(
                                    (() => showTransactionList(context)),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showTransactionList(BuildContext context) {
    if (boughtItemsController.isDoneLoading.value &&
        boughtItemsController.soldItems.isNotEmpty) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            itemCount: boughtItemsController.soldItems.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: boughtItemsController.soldItems[index].getBuyerInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (kIsWeb) {
                        return customTableRow(
                            boughtItemsController.soldItems[index]);
                      }
                      return mobileVersion(
                          boughtItemsController.soldItems[index]);
                    }
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  });
            }),
      );
    } else if (boughtItemsController.isDoneLoading.value &&
        boughtItemsController.soldItems.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'You have not purchase an items yet'));
    }

    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget header() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Item',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Seller',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Transaction Date',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text('Asking Price',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Bought At',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Action',
                    style: robotoMedium.copyWith(
                        color: blackColor, fontSize: kIsWeb ? 17 : 16)),
              ),
            ),
          ],
        ));
  }

  Widget customTableRow(SoldItem item) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(item.title,
                      style: robotoLight.copyWith(
                          color: greyColor, fontSize: kIsWeb ? 15 : 16)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(item.buyerName,
                      style: robotoLight.copyWith(
                          color: greyColor, fontSize: kIsWeb ? 15 : 16)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    Format.date(item.dateSold),
                    style: robotoLight.copyWith(
                        color: greyColor, fontSize: kIsWeb ? 15 : 16),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '₱ ${Format.amount(item.askingPrice)}',
                    style: robotoLight.copyWith(
                        color: greyColor, fontSize: kIsWeb ? 15 : 16),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('₱ ${Format.amount(item.soldAt)}',
                      style: robotoLight.copyWith(
                          color: greyColor, fontSize: kIsWeb ? 15 : 16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      'View',
                      style: robotoRegularUnderlined.copyWith(
                          color: brownColor, fontSize: kIsWeb ? 15 : 16),
                    ),
                  ),
                ),
              ),
            ]));
  }

//Mobile Version
  Widget phoneHeaderVersion() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('Item',
                    style:
                        robotoMedium.copyWith(color: blackColor, fontSize: 16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text('Transaction Date',
                    style:
                        robotoMedium.copyWith(color: blackColor, fontSize: 16)),
              ),
            ),
          ],
        ));
  }

  Widget mobileVersion(SoldItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    item.title,
                    style: robotoLight.copyWith(color: greyColor, fontSize: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  Format.date(item.dateSold),
                  style: robotoLight.copyWith(color: greyColor, fontSize: 14),
                ),
              ),
            ),
          ]),
    );
  }
}
