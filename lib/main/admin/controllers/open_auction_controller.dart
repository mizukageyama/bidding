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
  final TextEditingController sellerKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

  @override
  void onInit() {
    openItems.bindStream(getOpenAuctions());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
      filtered.assignAll(openItems);
    });
    ever(openItems, (openItems) => _updateList());
    super.onInit();
  }

  void _updateList() {
    if (!filtering.value) {
      filtered.assignAll(openItems);
    }
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

  get hasInputKeywords => titleKeyword.text != '' || sellerKeyword.text != '';

  //Search Functions
  void filterItems() {
    filtering.value = true;

    final RxList<Item> itemHolder = RxList.empty(growable: true);
    itemHolder.assignAll(openItems);

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

    //Search Item Seller Name
    if (sellerKeyword.text != '') {
      for (final item in List<Item>.from(itemHolder)) {
        if (!item.sellerInfo!.fullName
            .toString()
            .toLowerCase()
            .contains(sellerKeyword.text.toLowerCase())) {
          itemHolder.remove(item);
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
    sellerKeyword.clear();
    sortOption.value = '';
    filtered.clear();
    filtered.assignAll(openItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  void changeAscDesc() {
    asc.value = !asc.value;
  }

  void sortItems() {
    if (sortOption.value == 'Asking Price') {
      sortByAskingPrice();
    } else if (sortOption.value == 'Closing Date') {
      sortByDateClosing();
    } else if (sortOption.value == 'Item Title') {
      sortByDateItemTitle();
    }
    return;
  }

  void sortByAskingPrice() {
    if (asc.value) {
      filtered.sort((a, b) => a.askingPrice.compareTo(b.askingPrice));
    } else {
      filtered.sort((a, b) => b.askingPrice.compareTo(a.askingPrice));
    }
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
