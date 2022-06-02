import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/cupertino.dart';

class SoldAuctionController extends GetxController {
  final log = getLogger('Sold Auction Controller');

  final RxList<SoldItem> soldAuction = RxList.empty(growable: true);
  final RxList<SoldItem> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    soldAuction.bindStream(getSoldAuction());
    Future.delayed(const Duration(seconds: 3), () {
      filtered.assignAll(soldAuction);
      isDoneLoading.value = true;
    });
  }

  Stream<List<SoldItem>> getSoldAuction() {
    log.i('Streaming sold Auctions');
    return firestore
        .collection('sold_items')
        .orderBy('end_date', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return SoldItem.fromJson(item.data());
      }).toList();
    });
  }

  void filterItems() {
    filtered.clear();
    if (titleKeyword.text == '') {
      filtered.assignAll(soldAuction);
    } else {
      for (final item in soldAuction) {
        if (item.title
            .toLowerCase()
            .contains(titleKeyword.text.toLowerCase())) {
          filtered.add(item);
        }
      }
    }
  }

  void refreshItem() {
    formKey.currentState!.reset();
    titleKeyword.clear();
    filtered.clear();
    filtered.assignAll(soldAuction);
  }
}
