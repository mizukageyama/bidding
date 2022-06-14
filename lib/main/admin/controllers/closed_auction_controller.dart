import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/cupertino.dart';

class ClosedAuctionController extends GetxController {
  final log = getLogger('Closed Auction Controller');

  final RxList<Item> closedItems = RxList.empty(growable: true); //original
  final RxList<Item> filtered =
      RxList.empty(growable: true); //display - holds filter
  final RxBool isDoneLoading = false.obs;

  final RxInt closedItemCount = 0.obs;

  //Filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  @override
  void onInit() {
    closedItems.bindStream(getOpenAuctions());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(closedItems);
    });
    ever(closedItems, (closedItems) => _updateList());
    super.onInit();
  }

  void _updateList() {
    if (!filtering.value) {
      filtered.assignAll(closedItems);
    }
  }

  Stream<List<Item>> getOpenAuctions() {
    log.i('Streaming Closed Auctions');
    return firestore
        .collection('items')
        .orderBy('end_date', descending: true)
        .where('end_date', isLessThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }

  get cCount => closedItems.length;

  void filterItems() {
    filtering.value = true;
    filtered.clear();
    if (titleKeyword.text == '') {
      filtered.assignAll(closedItems);
    } else {
      for (final item in closedItems) {
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
    filtered.assignAll(closedItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }
}
