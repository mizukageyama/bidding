import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class BidsController extends GetxController {
  final log = getLogger('Bids Controller');
  static final AuthController authController = Get.find();
  final UserModel user = authController.userModel.value!;
  final RxList<Bid> bids = RxList.empty(growable: true);
  final RxList<Bid> filteredBids = RxList.empty(growable: true);
  final TextEditingController bidInput = TextEditingController();
  final RxBool isDoneLoading = false.obs;
  final uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    log.i('onInit | Bids Controller');
  }

  void bindBidList(String itemId) {
    bids.clear();
    if (user.userRole == 'Bidder' || user.userRole == 'Admin') {
      bids.bindStream(getBids(itemId));
    } else {
      bids.bindStream(getBidsforBidder(itemId));
    }
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<Bid>> getBids(String itemId) {
    log.i('Streaming Item List');
    return firestore
        .collection('bids')
        .orderBy('amount', descending: true)
        .where('item_id', isEqualTo: itemId)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Bid.fromJson(item.data());
      }).toList();
    });
  }

  Stream<List<Bid>> getBidsforBidder(String itemId) {
    log.i('Streaming Item List');
    return firestore
        .collection('bids')
        .orderBy('amount', descending: true)
        .where('item_id', isEqualTo: itemId)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Bid.fromJson(item.data());
      }).toList();
    });
  }

  Iterable<Bid> filtered() {
    return List<Bid>.from(bids).where((bid) => bid.isApproved);
  }

  int approvedBid(List<Bid> bids) {
    for (int a = 0; a < bids.length; a++) {
      if (bids[a].isApproved) return a;
    }
    return -1;
  }

  Future<void> approveBid(Bid bid, Item item) async {
    showLoading();
    final String generatedNotifId = uuid.v4();

    final batch = firestore.batch();
    batch.update(
      firestore.collection('bids').doc(bid.bidId),
      {'is_approved': true},
    );

    batch.set(
      firestore
          .collection('users')
          .doc(bid.bidderId)
          .collection('notifications')
          .doc(generatedNotifId),
      {
        'title': 'A Bid has been Approved',
        'message':
            'Your Php ${bid.amount} bid for ${item.title} has been approved. '
                'You have the chance to win the auction.',
        'created_at': FieldValue.serverTimestamp(),
      },
    );

    batch.update(
      firestore
          .collection('users')
          .doc(bid.bidderId)
          .collection('additional_info')
          .doc('value'),
      {'notif_badge': FieldValue.increment(1)},
    );

    batch.commit().then((value) async {
      dismissDialog();
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'Something went wrong',
          errorDescription: 'An error occured while approving bid');
      log.i(onError);
    });
  }

  Future<void> setWinningBid(Item item, Bid bid) async {
    showLoading();
    final String generatedNotifId = uuid.v4();
    final String generatedOtp = uuid.v4().substring(0, 6);
    final batch = firestore.batch();

    batch.update(firestore.collection('items').doc(item.itemId), {
      'winning_bid': bid.bidId,
      'otp': generatedOtp,
    });

    batch.update(
      firestore.collection('bids').doc(bid.bidId),
      {'is_approved': true},
    );

    batch.set(
      firestore
          .collection('users')
          .doc(bid.bidderId)
          .collection('notifications')
          .doc(generatedNotifId),
      {
        'title': 'You Won an Auction!',
        'message': 'You won ${item.title} with the bid of Php ${bid.amount}. '
            'Please check your email for futher information.',
        'created_at': FieldValue.serverTimestamp(),
      },
    );

    batch.update(
      firestore
          .collection('users')
          .doc(bid.bidderId)
          .collection('additional_info')
          .doc('value'),
      {'notif_badge': FieldValue.increment(1)},
    );

    batch.commit().then((value) async {
      try {
        await bid.getBidderInfo();
        sendEmailToWinner(item, bid, generatedOtp);
        dismissDialog();
      } catch (error) {
        dismissDialog();
        showErrorDialog(
            errorTitle: 'Something went wrong',
            errorDescription:
                'An error occured while sending email to the auction winner');
        log.i(error);
      }
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'Something went wrong',
          errorDescription: 'An error occured while setting winner');
      log.i(onError);
    });
  }

  Future<void> sendEmailToWinner(Item item, Bid winningBid, String otp) async {
    try {
      await function.httpsCallable('sendEmailToAuctionWinner').call({
        "otp": otp,
        "first_name": winningBid.bidderInfo?.fullName,
        "item_id": item.itemId,
        "item_title": item.title,
        "item_condition": item.condition,
        "item_category": item.category.join(', '),
        "asking_price": item.askingPrice,
        "winner_email": winningBid.bidderInfo?.email,
        "winning_bid": winningBid.amount,
        "seller_name": user.fullName,
        "seller_email": user.email,
        "seller_number": winningBid.bidderInfo?.contactNumber,
        "item_photo": item.images[0],
      }).then((value) async {
        log.i('Email sent to new winner');
      });
    } on FirebaseFunctionsException catch (error) {
      log.i(error);
    } catch (error) {
      log.i(error);
    }
  }

  Future<void> submitBid(
      String itemId, String sellerId, String itemTitle) async {
    final String generatedBidId = uuid.v4();
    final batch = firestore.batch();

    batch.set(firestore.collection('bids').doc(generatedBidId), {
      'bid_id': generatedBidId,
      'item_id': itemId,
      'bidder_id': auth.currentUser!.uid,
      'amount': double.parse(bidInput.text),
      'bid_date': Timestamp.now(),
      'is_approved': false,
    });

    batch.set(
        firestore
            .collection('users')
            .doc(sellerId)
            .collection('notifications')
            .doc(generatedBidId),
        {
          'title': 'New Bid has been Received',
          'message':
              '${user.fullName} has bid Php ${double.parse(bidInput.text)} for $itemTitle',
          'created_at': FieldValue.serverTimestamp(),
        });

    batch.update(
      firestore
          .collection('users')
          .doc(sellerId)
          .collection('additional_info')
          .doc('value'),
      {'notif_badge': FieldValue.increment(1)},
    );

    batch.commit().then((_) async {
      bidInput.clear();
      showSimpleDialog(
        title: 'Bid Sent Successfully',
        description:
            'Please wait for your bid to be approved by the seller. Thank you!',
      );
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
        errorTitle: 'Bid Failed',
        errorDescription: 'An error occurred. Please try again later.',
      );
    });
  }
}
