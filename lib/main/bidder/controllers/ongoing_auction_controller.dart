import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class OngoingAuctionController extends GetxController {
  final log = getLogger('Ongoing Auction Controller');

  final RxList<Item> itemList = RxList.empty(growable: true);
  final RxList<Item> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  //Filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();

  final RxBool filtering = false.obs;

  @override
  void onInit() {
    super.onInit();
    itemList.bindStream(getAuctionedItems());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(itemList);
    });
  }

  Stream<List<Item>> getAuctionedItems() {
    log.i('Streaming Item List');
    return firestore
        .collection('items')
        .orderBy('end_date')
        .where('end_date', isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }

  //Search Functions
  void filterItems() {
    filtering.value = true;
    filtered.clear();
    if (titleKeyword.text == '') {
      filtered.assignAll(itemList);
    } else {
      for (final item in itemList) {
        if (item.title
            .toLowerCase()
            .contains(titleKeyword.text.toLowerCase())) {
          filtered.add(item);
        }
      }
    }
  }

  void refreshItem() {
    filtering.value = false;
    formKey.currentState!.reset();
    titleKeyword.clear();
    filtered.clear();
    filtered.assignAll(itemList);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }
}
