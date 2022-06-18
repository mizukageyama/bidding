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
  final TextEditingController winnerKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

  @override
  void onInit() {
    super.onInit();

    soldItems.bindStream(getSoldItems());

    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(soldItems);
    });
    ever(soldItems, (soldItems) => _updateList());
  }

  void _updateList() {
    if (!filtering.value) {
      filtered.assignAll(soldItems);
    }
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

  get hasInputKeywords => titleKeyword.text != '' || winnerKeyword.text != '';

  //Search Functions
  void filterItems() {
    filtering.value = true;

    final RxList<SoldItem> itemHolder = RxList.empty(growable: true);
    itemHolder.assignAll(soldItems);

    //Search Item Title
    if (titleKeyword.text != '') {
      for (final item in List<SoldItem>.from(itemHolder)) {
        if (!item.title
            .toLowerCase()
            .contains(titleKeyword.text.toLowerCase())) {
          filtered.remove(item);
        }
      }
    }
    //Search Winner
    if (winnerKeyword.text != '') {
      for (final item in List<SoldItem>.from(itemHolder)) {
        if (!item.buyerName
            .toString()
            .toLowerCase()
            .contains(winnerKeyword.text.toLowerCase())) {
          filtered.remove(item);
        }
      }
    }
  }

  void refreshItem() {
    filtering.value = false;
    formKey.currentState!.reset();
    titleKeyword.clear();
    winnerKeyword.clear();
    filtered.clear();
    filtered.assignAll(soldItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  void changeAscDesc() {
    asc.value = !asc.value;
  }

  void sortItems() {
    if (sortOption.value == 'Item Title') {
      sortByItemTitle();
    } else if (sortOption.value == 'Date Sold') {
      sortBySoldDate();
    }
    return;
  }

  void sortByItemTitle() {
    if (asc.value) {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else {
      filtered.sort((a, b) => b.title.compareTo(a.title));
    }
  }

  void sortBySoldDate() {
    if (asc.value) {
      filtered.sort((a, b) => a.dateSold.compareTo(b.dateSold));
    } else {
      filtered.sort((a, b) => b.dateSold.compareTo(a.dateSold));
    }
  }
}
