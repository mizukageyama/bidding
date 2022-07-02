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

  Future<void> approveBid(String bidId) async {
    await firestore.collection('bids').doc(bidId).update({'is_approved': true});
  }

  Future<void> setWinningBid(Item item, String bidId) async {
    showLoading();
    final batch = firestore.batch();
    batch.update(firestore.collection('items').doc(item.itemId), {
      'winning_bid': bidId,
    });
    batch.update(
      firestore.collection('bids').doc(bidId),
      {'is_approved': true},
    );

    batch.commit().then((value) async {
      try {
        Bid winningBid = await firestore
            .collection("bids")
            .doc(bidId)
            .get()
            .then((doc) => Bid.fromJson(doc.data()!));
        await winningBid.getBidderInfo();
        sendEmailToWinner(item, winningBid);
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

  Future<void> sendEmailToWinner(Item item, Bid winningBid) async {
    try {
      await function.httpsCallable('sendEmailToAuctionWinner').call({
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
        "item_photo": item.images[0],
      }).then((value) {
        //TO DO: set notification
        log.i('Email sent to new winner');
      });
    } on FirebaseFunctionsException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }

  Future<void> submitBid(String itemId) async {
    final String generatedItemId = uuid.v4();
    await firestore.collection('bids').doc(generatedItemId).set({
      'bid_id': generatedItemId,
      'item_id': itemId,
      'bidder_id': auth.currentUser!.uid,
      'amount': double.parse(bidInput.text),
      'bid_date': Timestamp.now(),
      'is_approved': false,
    }).then((value) {
      bidInput.clear();
      showSimpleDialog(
        title: 'Bid Sent Successfully',
        description:
            'Please wait for your bid to be approved by the seller. Thank you!',
      );
    });
  }
}
