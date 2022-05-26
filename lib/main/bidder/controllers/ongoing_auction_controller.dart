import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class OngoingAuctionController extends GetxController {
  final log = getLogger('Ongoing Auction Controller');

  final RxList<Item> itemList = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    itemList.bindStream(getAuctionedItems());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<Item>> getAuctionedItems() {
    log.i('Streaming Item List');
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
}
