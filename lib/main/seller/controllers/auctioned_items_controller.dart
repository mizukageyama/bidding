import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class AuctionedItemController extends GetxController {
  final log = getLogger('Auctioned Item Controller');

  final RxList<Item> itemList = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  //Dashboard
  final RxInt closedItemCount = 0.obs;
  final RxInt openedItemCount = 0.obs;

  //Reopening Closed Item - Date and Time Input
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final RxString time = ''.obs;
  final RxString date = ''.obs;

  @override
  void onInit() {
    itemList.bindStream(getItemsForSeller());
    _updateCount();
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
    ever(itemList, (itemList) => _updateCount());
    super.onInit();
  }

  Stream<List<Item>> getItemsForSeller() {
    log.i('Streaming Item List');
    return firestore
        .collection('items')
        .orderBy('end_date')
        .where('seller_id', isEqualTo: auth.currentUser!.uid)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }

  void _updateCount() {
    updateClosedItemCount();
    updateOpenedItemCount();
  }

  get oCount => openedItemCount.value;

  get cCount => closedItemCount.value;

  void updateClosedItemCount() {
    List<Item> temp = itemList
        .where((data) => DateTime.now().isAfter(data.endDate.toDate()))
        .toList();
    closedItemCount.value = temp.length;
  }

  void updateOpenedItemCount() {
    List<Item> temp = itemList
        .where((data) => DateTime.now().isBefore(data.endDate.toDate()))
        .toList();
    openedItemCount.value = temp.length;
  }
}
