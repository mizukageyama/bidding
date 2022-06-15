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
  final RxSet<String> categoryKeyWords = <String>{}.obs;
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

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

  get hasInputKeywords =>
      titleKeyword.text != '' || categoryKeyWords.isNotEmpty;

  // //Search Functions
  // void filterItems() {
  //   filtering.value = true;
  //   filtered.clear();
  //   if (titleKeyword.text == '') {
  //     filtered.assignAll(itemList);
  //   } else {
  //     for (final item in itemList) {
  //       if (item.title
  //           .toLowerCase()
  //           .contains(titleKeyword.text.toLowerCase())) {
  //         filtered.add(item);
  //       }
  //     }
  //   }
  // }

//Search Functions
  void filterItems() {
    filtering.value = true;

    final RxList<Item> itemHolder = RxList.empty(growable: true);
    itemHolder.assignAll(itemList);

    //Search Item Title
    if (titleKeyword.text != '') {
      for (final item in List<Item>.from(itemHolder)) {
        if (!item.title
            .toLowerCase()
            .contains(titleKeyword.text.toLowerCase())) {
          itemHolder.remove(item);
        }
      }
    }

    //Search Item By Category
    if (categoryKeyWords.isNotEmpty) {
      for (final item in List<Item>.from(itemHolder)) {
        if (item.category.length < categoryKeyWords.length) {
          itemHolder.remove(item);
        } else {
          List<String> itemCategory = List.from(item.category);
          final int originalLength = itemCategory.length;
          itemCategory.removeWhere((item) => categoryKeyWords.contains(item));
          if (itemCategory.length !=
              (originalLength - categoryKeyWords.length)) {
            itemHolder.remove(item);
          }
        }
      }
    }

    filtered.clear();
    filtered.assignAll(itemHolder);
    sortItems();
  }

  void refreshItem() {
    filtering.value = false;
    formKey.currentState!.reset();
    titleKeyword.clear();
    categoryKeyWords.clear();
    sortOption.value = '';
    filtered.clear();
    filtered.assignAll(itemList);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  void changeAscDesc() {
    asc.value = !asc.value;
  }

  void sortItems() {
    if (sortOption.value == 'Closing Date') {
      sortByDateClosing();
    } else if (sortOption.value == 'Item Title') {
      sortByDateItemTitle();
    }
    return;
  }

  void sortByDateClosing() {
    if (asc.value) {
      filtered.sort((a, b) => a.endDate.compareTo(b.endDate));
    } else {
      filtered.sort((a, b) => b.endDate.compareTo(a.endDate));
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
