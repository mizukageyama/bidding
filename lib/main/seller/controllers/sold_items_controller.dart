import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class SoldItemsController extends GetxController {
  final log = getLogger('Sold Item List Controller');

  final RxList<SoldItem> soldItems = RxList.empty(growable: true);
  final RxList<SoldItem> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  //Filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  @override
  void onInit() {
    super.onInit();

    soldItems.bindStream(getSoldItems());

    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
      filtered.assignAll(soldItems);
    });
  }

  Stream<List<SoldItem>> getSoldItems() {
    log.i('Streaming Item List');
    return firestore
        .collection('sold_items')
        .orderBy('end_date', descending: true)
        .where('seller_id', isEqualTo: auth.currentUser!.uid)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return SoldItem.fromJson(item.data());
      }).toList();
    });
  }

  //Search Functions
  void filterItems() {
    filtering.value = true;
    filtered.clear();
    if (titleKeyword.text == '') {
      filtered.assignAll(soldItems);
    } else {
      for (final item in soldItems) {
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
    filtered.assignAll(soldItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  get emptySearchResultSearchResultMessage {
    return titleKeyword.text;
  }
}
