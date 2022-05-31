import 'package:bidding/components/category_chip.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/components/display_price.dart';
import 'package:bidding/components/item_info_left_column.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/layout/test_side_menu.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpenClosedItemView extends StatelessWidget {
  //const OpenClosedItemView({Key? key, required this.item}) : super(key: key);
  final Item item = Item(
    itemId: 'MsRyfhQOhK2IwiSaNT94',
    sellerId: 'K0ASoOxiUSSGDX9CoNE8Yfr7Ll33',
    title: 'Raspberry Pi, and Arduino Sensors',
    description:
        'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    winningBid: '',
    askingPrice: 200,
    category: ['Arduino', 'Electronics'],
    condition: 'Good as New',
    brand: '',
    endDate: Timestamp(0, 1652000),
    images: [
      'https://firebasestorage.googleapis.com/v0/b/bidding-7c695.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2FRaspberry%20Pi-PI4%20MODEL%20B_1GB-30152779-01.jpg?alt=media&token=3b8ef48f-ab0b-4acd-8e6a-ef879c967fd0',
      'https://firebasestorage.googleapis.com/v0/b/bidding-7c695.appspot.com/o/item_images%2FMsRyfhQOhK2IwiSaNT94%2FRPi3-1024x768.jpg?alt=media&token=ef01c579-368e-4298-b952-543a2ab21519'
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ResponsiveView(
          _Content(
            item: item,
          ),
          MobileSliver(
            title: 'Item Info > Item Title Here',
            body: _Content(
              item: item,
            ),
          ),
          TestSideMenu(),
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
          kIsWeb && Get.width >= 600
              ? Container(
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
                          'Item Info > Item Title Here',
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
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
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
  const _RightColumn({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
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
          DisplayInfo(
            title: 'Highest Approved Bid',
            content: '₱ ${Format.amount(1000)}',
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
            runSpacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayInfo(
                        title: 'Item Posted By', content: 'Anne Curtis Smith'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      Format.date(item.endDate),
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
                            countdownTimer(item.endDate),
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
          // Text(
          //   'Item ${DateTime.now().isBefore(item.endDate.toDate()) ? 'will be' : 'was'} closed: ${Format.date(item.endDate)}',
          //   style: robotoRegular.copyWith(color: greyColor),
          // ),
        ],
      ),
    );
  }
}

Widget countdownTimer(Timestamp dt) {
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
