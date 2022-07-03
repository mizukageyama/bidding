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
  final TextEditingController sellerKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

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

  get hasInputKeywords => titleKeyword.text != '' || sellerKeyword.text != '';

  void filterItems() {
    filtering.value = true;
    final RxList<Item> itemHolder = RxList.empty(growable: true);
    itemHolder.assignAll(closedItems);

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

    //Search Seller Name
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
  }

  void refreshItem() {
    filtering.value = false;
    formKey.currentState!.reset();
    titleKeyword.clear();
    sellerKeyword.clear();
    sortOption.value = '';
    filtered.clear();
    filtered.assignAll(closedItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

//sort Items

  void changeAscDesc() {
    asc.value = !asc.value;
  }

  void sortItems() {
    if (sortOption.value == 'Winner Selected') {
      sortByWinnerSelected();
    } else if (sortOption.value == 'Asking Price') {
      sortByAskingPrice();
    } else if (sortOption.value == 'Date Closed') {
      sortByDateClosed();
    }
    return;
  }

  void sortByWinnerSelected() {
    if (asc.value) {
      filtered.sort((a, b) => b.winningBid.compareTo(a.winningBid));
    } else {
      filtered.sort((a, b) => a.winningBid.compareTo(b.winningBid));
    }
  }

  void sortByAskingPrice() {
    if (asc.value) {
      filtered.sort((a, b) => a.askingPrice.compareTo(b.askingPrice));
    } else {
      filtered.sort((a, b) => b.askingPrice.compareTo(a.askingPrice));
    }
  }

  void sortByDateClosed() {
    if (asc.value) {
      filtered.sort((a, b) => a.endDate.compareTo(b.endDate));
    } else {
      filtered.sort((a, b) => b.endDate.compareTo(a.endDate));
    }
  }
}
