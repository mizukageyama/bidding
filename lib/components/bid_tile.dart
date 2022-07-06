import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidTile extends StatelessWidget {
  BidTile(
      {Key? key,
      required this.bid,
      this.showAll = false,
      required this.item,
      required this.isBidder})
      : super(key: key);

  final BidsController bidsController = Get.find();
  final Bid bid;
  final bool showAll;
  final bool isBidder;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: bid.getBidderInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showAll ? longTile(bid) : shortTile(bid);
          }
          return const SizedBox(
            height: 0,
            width: 0,
          );
        });
  }

  Widget shortTile(Bid bid) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              bid.bidderInfo!.firstName,
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '₱  ${Format.amount(bid.amount)}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          SizedBox(
            width: 40,
            child: bid.isApproved || item.winningBid.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: bid.isApproved,
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: orangeColor,
                          size: 18,
                        ),
                      ),
                      Visibility(
                        visible: !isBidder && bid.bidId == item.winningBid,
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.yellow,
                          size: 18,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          )
        ],
      ),
    );
  }

  Widget longTile(Bid bid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: kIsWeb && Get.width >= 600 ? 2 : 1,
            child: Text(
              '${bid.bidderInfo!.firstName} ${bid.bidderInfo!.lastName}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Text(
              '₱ ${Format.amount(bid.amount)}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          Get.width >= 600
              ? Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        flex: kIsWeb ? 3 : 2,
                        child: Text(
                          Format.date(bid.bidDate),
                          style: robotoRegular.copyWith(color: greyColor),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 70,
            child: Column(
              children: [
                bid.isApproved || item.winningBid.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: bid.isApproved,
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: orangeColor,
                              size: 18,
                            ),
                          ),
                          Visibility(
                            visible: bid.bidId == item.winningBid,
                            child: const Icon(
                              Icons.emoji_events,
                              color: Colors.yellow,
                              size: 18,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                Visibility(
                  visible: !bid.isApproved &&
                      !(bid.bidId == item.winningBid) &&
                      DateTime.now().isBefore(item.endDate.toDate()),
                  child: InkWell(
                    onTap: () async {
                      await bidsController.approveBid(bid, item);
                    },
                    child: Text(
                      'Approve',
                      style: robotoRegular.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isBidder &&
                      DateTime.now().isAfter(item.endDate.toDate()) &&
                      bid.bidId != item.winningBid &&
                      item.winningBid == '',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: InkWell(
                      onTap: () async {
                        await bidsController.setWinningBid(item, bid.bidId);
                      },
                      child: Text(
                        'Set winner',
                        style: robotoRegular.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
