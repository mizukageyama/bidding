import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class OpenAuctionController extends GetxController {
  final log = getLogger('Open Auction Controller');

  final RxList<Item> openItems = RxList.empty(growable: true);
  final RxList<Item> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  final RxInt openItemCount = 0.obs;

  //Filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  @override
  void onInit() {
    super.onInit();
    openItems.bindStream(getOpenAuctions());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(openItems);
    });
  }

  Stream<List<Item>> getOpenAuctions() {
    log.i('Streaming Open Auctions');
    return firestore
        .collection('items')
        .orderBy('end_date', descending: true)
        .where('end_date', isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }

  get oCount => openItems.length;

  //Search Functions
  void filterItems() {
    filtering.value = true;
    filtered.clear();
    if (titleKeyword.text == '') {
      filtered.assignAll(openItems);
    } else {
      for (final item in openItems) {
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
    filtered.assignAll(openItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  get searchKey {
    return titleKeyword.text;
  }
}
