import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoughtItemsController extends GetxController {
  final log = getLogger('Bought Item List Controller');

  final RxList<SoldItem> soldItems = RxList.empty(growable: true);
  final RxList<SoldItem> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  //Filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString date = ''.obs;
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

  @override
  void onInit() {
    soldItems.bindStream(getBoughtItemsBidder());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(soldItems);
    });
    super.onInit();
  }

  Stream<List<SoldItem>> getBoughtItemsBidder() {
    log.i('Streaming Item List');
    return firestore
        .collection('sold_items')
        .orderBy('date_sold', descending: true)
        .where('buyer_id', isEqualTo: auth.currentUser!.uid)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return SoldItem.fromJson(item.data());
      }).toList();
    });
  }

  get hasInputKeywords => titleKeyword.text != '' || date.value != '';

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
          itemHolder.remove(item);
        }
      }
    }

    //Search Date
    if (date.value != '') {
      for (final item in List<SoldItem>.from(itemHolder)) {
        String dateSold = DateFormat.yMMMd().format(item.dateSold.toDate());
        if (dateSold != date.value) {
          itemHolder.remove(item);
        }
      }
    }

    filtered.clear();
    filtered.assignAll(itemHolder);
    sortItems();
  }

  //refreshDate
  void refreshItem() {
    filtering.value = false;
    formKey.currentState!.reset();
    titleKeyword.clear();
    date.value = '';
    sortOption.value = '';
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
    if (sortOption.value == 'Bought At') {
      sortBySoldAt();
    } else if (sortOption.value == 'Date Sold') {
      sortByDateSold();
    } else if (sortOption.value == 'Item Title') {
      sortByDateItemTitle();
    }
    return;
  }

  void sortBySoldAt() {
    if (asc.value) {
      filtered.sort((a, b) => a.soldAt.compareTo(b.soldAt));
    } else {
      filtered.sort((a, b) => b.soldAt.compareTo(a.soldAt));
    }
  }

  void sortByDateSold() {
    if (asc.value) {
      filtered.sort((a, b) => a.dateSold.compareTo(b.dateSold));
    } else {
      filtered.sort((a, b) => b.dateSold.compareTo(a.dateSold));
    }
  }

  void sortByDateItemTitle() {
    if (asc.value) {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else {
      filtered.sort((a, b) => b.title.compareTo(a.title));
    }
  }
}
