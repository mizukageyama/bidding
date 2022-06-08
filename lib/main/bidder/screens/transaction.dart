import 'package:bidding/components/_components.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your successful transactions',
                        style: robotoMedium.copyWith(
                            color: blackColor, fontSize: kIsWeb ? 16 : 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 20,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            width: 125,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Obx(
                                () => Text(
                                    boughtItemsController.date.value == ''
                                        ? 'Select Date'
                                        : boughtItemsController
                                            .date.value), //filteredItem
                              ),
                            )),
                        IconButton(
                          onPressed: () {
                            boughtItemsController.refreshItem();
                          },
                          icon: const Icon(Icons.refresh),
                          iconSize: 25,
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: Get.height * .8,
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: blackColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kIsWeb && Get.width >= 900
                                  ? header()
                                  : phoneHeaderVersion(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDate(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: () async {
          DateTime? selected = await showDatePicker(
            context: context,
            initialDate: boughtItemsController.selectedDate.value,
            firstDate: DateTime(2010),
            lastDate: DateTime(2025),
          );

          if (selected != null) {
            boughtItemsController.date.value =
                DateFormat.yMMMd().format(selected);
            boughtItemsController.filterDate();
          }
        },
        icon: const Icon(Icons.calendar_today),
        iconSize: 25,
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
            itemCount: boughtItemsController.filtered.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: boughtItemsController.filtered[index].getBuyerInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (kIsWeb && Get.width >= 900) {
                        return customTableRow(
                            boughtItemsController.filtered[index], context);
                      }
                      return mobileVersion(
                          boughtItemsController.filtered[index], context);
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
                child: Text('Date Sold',
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

  Widget customTableRow(SoldItem item, BuildContext context) {
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
                    onTap: () {
                      showTransactionInfo(context, item);
                    },
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('Date Sold',
                    style:
                        robotoMedium.copyWith(color: blackColor, fontSize: 16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('Action',
                    style:
                        robotoMedium.copyWith(color: blackColor, fontSize: 16)),
              ),
            ),
          ],
        ));
  }

  Widget mobileVersion(SoldItem item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  item.title,
                  style: robotoLight.copyWith(color: greyColor, fontSize: 15),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  Format.date(item.dateSold),
                  style: robotoLight.copyWith(color: greyColor, fontSize: 15),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    showTransactionInfo(context, item);
                  },
                  child: Text('View',
                      style: robotoRegularUnderlined.copyWith(
                          color: maroonColor, fontSize: 15)),
                ),
              ),
            ),
          ]),
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
