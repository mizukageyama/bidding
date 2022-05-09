import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class ItemListController extends GetxController {
  final log = getLogger('Item List Controller');

  final RxList<Item> itemList = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    itemList.bindStream(getItemListStream());
    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<Item>> getItemListStream() {
    log.i('Streaming Item List');
    return firestore
        .collection('items')
        .orderBy('end_date')
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }
}
