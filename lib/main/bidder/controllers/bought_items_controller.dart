import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:intl/intl.dart';

class BoughtItemsController extends GetxController {
  final log = getLogger('Bought Item List Controller');

  final RxList<SoldItem> soldItems = RxList.empty(growable: true);
  final RxList<SoldItem> filtered = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  //Filter Data
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString date = ''.obs;

  final RxBool filtering = false.obs;

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

  // filtered Date
  void filterDate() {
    print('filter date is click');
    filtering.value = true;
    filtered.clear();
    if (date.value == '') {
      filtered.assignAll(soldItems);
    } else {
      for (final item in soldItems) {
        String dateSold = DateFormat.yMMMd().format(item.dateSold.toDate());
        if (dateSold == date.value) {
          filtered.add(item);
        }
      }
    }
  }

  //refreshDate
  void refreshItem() {
    print('refresh is click');
    filtering.value = false;
    date.value = '';
    filtered.clear();
    filtered.assignAll(soldItems);
  }

  get emptySearchResult {
    return filtered.isEmpty && filtering.value;
  }
}
