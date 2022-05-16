import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class BidTile extends StatelessWidget {
  const BidTile({Key? key, required this.bid, this.showAll = false})
      : super(key: key);
  final Bid bid;
  final bool showAll;

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
              '₱  ${bid.ftAmount}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          SizedBox(
            width: 30,
            child: bid.isApproved
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: orangeColor,
                    size: 18,
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
            flex: 2,
            child: Text(
              '${bid.bidderInfo!.firstName} ${bid.bidderInfo!.lastName}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '₱  ${bid.ftAmount}',
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              bid.formattedDT,
              style: robotoRegular.copyWith(color: greyColor),
            ),
          ),
          SizedBox(
            width: 70,
            child: bid.isApproved
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: orangeColor,
                    size: 18,
                  )
                : InkWell(
                    onTap: () {
                      //update isApproved = true
                    },
                    child: Text(
                      'Approve',
                      style: robotoRegular.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
