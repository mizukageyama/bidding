import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class SoldItemsController extends GetxController {
  final log = getLogger('Sold Item List Controller');

  final RxList<SoldItem> soldItems = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    soldItems.bindStream(getSoldItems());

    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
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
}
