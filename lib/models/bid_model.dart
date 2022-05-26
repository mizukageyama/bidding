import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';

class Bid {
  final String bidId;
  final String itemId;
  final String bidderId;
  final double amount;
  final bool isApproved;
  final Timestamp bidDate;
  UserModel? bidderInfo;

  Bid({
    required this.bidId,
    required this.itemId,
    required this.bidderId,
    required this.amount,
    required this.isApproved,
    required this.bidDate,
    this.bidderInfo,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
        bidId: json['bid_id'] as String,
        itemId: json['item_id'] as String,
        bidderId: json['bidder_id'] as String,
        amount: double.parse('${json['amount']}'),
        bidDate: json['bid_date'] as Timestamp,
        isApproved: json['is_approved'] as bool);
  }

  Map<String, dynamic> toJson() => {
        'bid_id': bidId,
        'item_id': itemId,
        'bidder_id': bidderId,
        'amount': amount,
        'bid_date': bidDate,
        'is_approved': isApproved,
      };

  @override
  String toString() {
    return '{$toJson}';
  }

  Future<void> getBidderInfo() async {
    bidderInfo = await firestore
        .collection('users')
        .doc(bidderId)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
  }
}

class MyBid {
  final String bidId;
  final String itemId;
  final String bidderId;
  final double amount;
  final bool isApproved;
  final Timestamp bidDate;

  MyBid({
    required this.bidId,
    required this.itemId,
    required this.bidderId,
    required this.amount,
    required this.isApproved,
    required this.bidDate,
  });

  factory MyBid.fromJson(Map<String, dynamic> json) => MyBid(
        bidId: json['bid_id'] as String,
        itemId: json['item_id'] as String,
        bidderId: json['bidder_id'] as String,
        amount: json['amount'] as double,
        bidDate: json['bid_date'] as Timestamp,
        isApproved: json['is_approved'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'bid_id': bidId,
        'item_id': itemId,
        'bidder_id': bidderId,
        'amount': amount,
        'bid_date': bidDate,
        'is_approved': isApproved,
      };
}
