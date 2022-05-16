import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class SoldItemsController extends GetxController {
  final log = getLogger('Sold Item List Controller');

  static final AuthController authController = Get.find();
  final UserModel user = authController.userModel.value!;
  final RxList<SoldItem> soldItems = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (user.userRole == 'Seller') {
      soldItems.bindStream(getSoldItemsForSeller());
    } else {
      soldItems.bindStream(getBoughtItemsBidder());
    }
    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<SoldItem>> getSoldItemsForSeller() {
    log.i('Streaming Item List');
    return firestore
        .collection('sold_items')
        .orderBy('end_date', descending: true)
        .where('seller_id', isEqualTo: user.userID)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return SoldItem.fromJson(item.data());
      }).toList();
    });
  }

  Stream<List<SoldItem>> getBoughtItemsBidder() {
    log.i('Streaming Item List');
    return firestore
        .collection('items')
        .orderBy('end_date', descending: true)
        .where('bidder_id', isEqualTo: user.userID)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return SoldItem.fromJson(item.data());
      }).toList();
    });
  }
}
