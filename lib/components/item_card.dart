import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/screens/_bidder_screens.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  ItemCard({Key? key, required this.item, required this.isSoldItem})
      : super(key: key);

  static final AuthController authController = Get.find();
  final UserModel user = authController.userModel.value!;
  final dynamic item;
  final bool isSoldItem;

  int endTime() {
    return item.endDate.millisecondsSinceEpoch + 1000 * 30;
  }

  void navigateToInfo(dynamic item) {
    if (user.userRole == 'Seller') {
      if (!isSoldItem) {
        Get.to(
          () => ItemInfoScreen(item: item, id: item.itemId),
        );
      } else {
        Get.to(
          () => SoldItemInfoScreen(item: item),
        );
      }
    } else if (user.userRole == 'Bidder') {
      Get.to(
        () => OngoingAuctionInfoScreen(item: item),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToInfo(item);
      },
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: whiteColor, border: Border.all(color: neutralColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ImageView(
                imageUrl: item.images[0],
                height: kIsWeb ? Get.height / 4 : 140,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  color: blackColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(
                  color: greyColor,
                  fontSize: 13,
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Flexible(
              //   child: Wrap(
              //     spacing: 5,
              //     runSpacing: 5,
              //     children: [...categories()],
              //   ),
              // )
            ],
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          child: countdownCard(),
          width: 120,
        ),
      ]),
    );
  }

  Widget countdownCard() {
    return Container(
      color: orangeColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: countdownTimer(),
    );
  }

  Widget countdownTimer() {
    return CountdownTimer(
      endTime: endTime(),
      widgetBuilder: (_, time) {
        if (time == null) {
          return Center(
            child: Text(
              isSoldItem ? 'SOLD' : 'CLOSED',
              style: robotoMedium.copyWith(
                color: whiteColor,
                fontSize: 17,
              ),
            ),
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
              color: whiteColor,
              fontSize: 17,
            ),
          );
        }

        return Text(
          '$days ${days > 1 ? 'days' : 'day'} and\n$minutes : $seconds left',
          style: robotoMedium.copyWith(
            color: whiteColor,
            fontSize: 17,
          ),
        );
      },
    );
  }

  List<Chip> categories() {
    return item.category
        .map(
          (data) => Chip(
            backgroundColor: blackColor,
            label: Text(
              data,
              style: const TextStyle(color: whiteColor, fontSize: 10),
            ),
          ),
        )
        .toList();
  }
}
