import 'package:bidding/models/_models.dart';
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

  final RxInt soldItemCount = 0.obs;

//filter Data
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleKeyword = TextEditingController();
  final TextEditingController sellerKeyword = TextEditingController();
  final RxBool filtering = false.obs;

  //Sort
  final RxString sortOption = ''.obs;
  final RxBool asc = true.obs;

  @override
  void onInit() {
    soldAuction.bindStream(getSoldAuction());
    Future.delayed(const Duration(seconds: 3), () {
      filtered.assignAll(soldAuction);
      isDoneLoading.value = true;
    });
    ever(soldAuction, (soldAuction) => _updateList());
    super.onInit();
  }

  void _updateList() {
    if (!filtering.value) {
      filtered.assignAll(soldAuction);
    }
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

  get sCount => soldAuction.length;

  get hasInputKeywords => titleKeyword.text != '' || sellerKeyword.text != '';

  void filterItems() {
    filtering.value = true;
    final RxList<SoldItem> itemHolder = RxList.empty(growable: true);
    itemHolder.assignAll(soldAuction);

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

    //Search Seller Name
    if (sellerKeyword.text != '') {
      for (final item in List<SoldItem>.from(itemHolder)) {
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

    filtered.clear();
    filtered.assignAll(soldAuction);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }

  //sort Items
  void changeAscDesc() {
    asc.value = !asc.value;
  }

  void sortItems() {
    if (sortOption.value == 'Sold Date') {
      sortBySoldDate();
    } else if (sortOption.value == 'Item Title') {
      sortByItemTitle();
    }
    return;
  }

  void sortBySoldDate() {
    if (asc.value) {
      filtered.sort((a, b) => a.dateSold.compareTo(b.dateSold));
    } else {
      filtered.sort((a, b) => b.dateSold.compareTo(a.dateSold));
    }
  }

  void sortByItemTitle() {
    if (asc.value) {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else {
      filtered.sort((a, b) => b.title.compareTo(a.title));
    }
  }
}
