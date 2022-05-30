import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class OpenAuctionController extends GetxController {
  final log = getLogger('Closed Auction Controller');

  final RxList<Item> closedItems = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    closedItems.bindStream(getOpenAuctions());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
    super.onInit();
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
}
