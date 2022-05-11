import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class BidsController extends GetxController {
  final log = getLogger('Bids Controller');

  @override
  void onInit() {
    super.onInit();
    log.i('onInit | Bids Controller');
  }

  Stream<List<Bid>> getBids(String itemId) {
    log.i('Streaming Item List');
    return firestore
        .collection('bids')
        .orderBy('amount')
        .where('item_id', isEqualTo: itemId)
        .limit(5)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Bid.fromJson(item.data());
      }).toList();
    });
  }
}
