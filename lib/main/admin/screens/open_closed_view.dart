import 'package:bidding/components/_components.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpenClosedItemView extends StatelessWidget {
  OpenClosedItemView({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: ResponsiveView(
          _Content(
            item: item,
          ),
          AdminSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
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
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    'Item Info > ${item.title}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: whiteColor,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
          kIsWeb && Get.width >= 600
              ? Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LeftColumn(
                              images: item.images,
                            ),
                          ),
                          Expanded(
                            child: _RightColumn(
                              item: item,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      LeftColumn(
                        images: item.images,
                      ),
                      _RightColumn(
                        item: item,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _RightColumn extends StatelessWidget {
  _RightColumn({Key? key, required this.item}) : super(key: key);
  final BidsController bidsController = Get.put(BidsController());
  final Item item;

  @override
  Widget build(BuildContext context) {
    bidsController.bindBidList(item.itemId);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title.toUpperCase(),
            style: robotoBold.copyWith(
              color: maroonColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          DisplayInfo(title: 'Description', content: item.description),
          const SizedBox(
            height: 15,
          ),
          DisplayInfo(title: 'Condition', content: item.condition),
          const SizedBox(
            height: 15,
          ),
          item.brand == ''
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayInfo(title: 'Brand', content: item.brand),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          CategoryChip(
            items: item.category,
          ),
          const SizedBox(
            height: 15,
          ),
          DisplayInfo(
              title: 'Asking Price',
              content: '₱ ${Format.amount(item.askingPrice)}'),
          const SizedBox(
            height: 15,
          ),
          DateTime.now().isAfter(item.endDate.toDate()) && item.winningBid != ''
              ? _displaySelectedWinner()
              : Obx(() => _displayPrice()),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            runSpacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item Posted By',
                        style: robotoMedium.copyWith(
                          color: blackColor,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: item.getSellerInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              item.sellerInfo!.fullName,
                              style: robotoRegular.copyWith(
                                color: greyColor,
                                fontSize: 14,
                              ),
                            );
                          }
                          return Text(
                            '',
                            style: robotoRegular.copyWith(
                              color: greyColor,
                              fontSize: 14,
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      Format.date(item.datePosted),
                      style: robotoRegular.copyWith(color: greyColor),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTime.now().isAfter(item.endDate.toDate())
                        ? 'Item Closed'
                        : 'Closing On',
                    style: robotoMedium.copyWith(
                      color: blackColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DateTime.now().isBefore(item.endDate.toDate())
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _countdownTimer(item.endDate),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  Text(
                    Format.date(item.endDate),
                    style: robotoRegular.copyWith(color: greyColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _displayPrice() {
    if (bidsController.isDoneLoading.value && bidsController.bids.isNotEmpty) {
      int index = bidsController.approvedBid(bidsController.bids);
      if (index != -1) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DisplayInfo(
              title: 'Highest Approved Bid',
              content: '₱ ${Format.amount(bidsController.bids[index].amount)}',
              isPrice: true,
            ),
          ],
        );
      } else {
        return const InfoDisplay(
            message: 'No approved from the bids at the moment.');
      }
    } else if (bidsController.isDoneLoading.value &&
        bidsController.bids.isEmpty) {
      return const InfoDisplay(message: 'No bids for this item at the moment.');
    }
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        color: maroonColor,
      ),
    );
  }

  Widget _displaySelectedWinner() {
    return FutureBuilder(
        future: item.getWinnerInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayInfo(
                  isPrice: true,
                  title: 'Selected Winner',
                  content: '₱ ${Format.amount(item.winningBidInfo!.amount)}',
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('by ${item.winningBidInfo!.bidderInfo!.fullName}')
              ],
            );
          }
          return const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: maroonColor,
              ));
        });
  }

  Widget _countdownTimer(Timestamp dt) {
    return CountdownTimer(
      endTime: dt.millisecondsSinceEpoch + 1000 * 30,
      widgetBuilder: (_, time) {
        if (time == null) {
          return const SizedBox(
            height: 0,
          );
        }
        int days = time.days ?? 0;
        int daysToHours = days * 24;
        int hours = time.hours ?? 0;
        int overallHours = hours + daysToHours;
        int minutes = time.min ?? 0;
        int seconds = time.sec ?? 0;

        if (days == 0) {
          return Text(
            '${overallHours < 10 ? '0$overallHours' : overallHours} '
            ': ${minutes < 10 ? '0$minutes' : minutes} : ${seconds < 10 ? '0$seconds' : seconds} left',
            style: robotoMedium.copyWith(
              color: maroonColor,
              fontSize: 17,
            ),
          );
        }

        return Text(
          '$days ${days > 1 ? 'days' : 'day'} and\n$minutes : $seconds left',
          style: robotoMedium.copyWith(
            color: maroonColor,
            fontSize: 17,
          ),
        );
      },
    );
  }
}
