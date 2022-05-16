import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class BidsController extends GetxController {
  final log = getLogger('Bids Controller');
  final RxList<Bid> bids = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    log.i('onInit | Bids Controller');
  }

  void bindBidList(String itemId) {
    bids.bindStream(getBids(itemId));
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<Bid>> getBids(String itemId) {
    log.i('Streaming Item List');
    return firestore
        .collection('bids')
        .orderBy('amount', descending: true)
        .where('item_id', isEqualTo: itemId)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Bid.fromJson(item.data());
      }).toList();
    });
  }

  int approvedBid(List<Bid> bids) {
    for (int a = 0; a < bids.length; a++) {
      if (bids[a].isApproved) return a;
    }
    return -1;
  }
}
