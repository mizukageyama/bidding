import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class BidTile extends StatelessWidget {
  const BidTile({Key? key, required this.bid, this.showAll = false})
      : super(key: key);
  final Bid bid;
  final bool showAll;

  Future<void> _getBidder() async {
    bid.bidderInfo = await firestore
        .collection('users')
        .doc(bid.bidderId)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getBidder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showAll ? longTile(bid) : shortTile(bid);
          }
          return const SizedBox(
            width: 0,
            height: 0,
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
    return Row();
  }
}
