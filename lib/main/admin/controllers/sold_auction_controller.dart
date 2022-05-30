import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class SoldAuctionController extends GetxController {
  final log = getLogger('Sold Auction Controller');

  final RxList<SoldItem> soldAuction = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    soldAuction.bindStream(getSoldAuction());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
    super.onInit();
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
}
