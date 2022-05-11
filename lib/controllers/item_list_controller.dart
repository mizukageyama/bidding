import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';

class ItemListController extends GetxController {
  final log = getLogger('Item List Controller');

  //static final AuthController authController = Get.find();
  //final UserModel user = authController.userModel.value!;
  final RxList<Item> itemList = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    //if (user.isSeller!) {
    itemList.bindStream(getItemsForSeller());
    // } else {
    //   itemList.bindStream(getItemsForBidder());
    // }
    Future.delayed(const Duration(seconds: 5), () {
      isDoneLoading.value = true;
    });
  }

  Stream<List<Item>> getItemsForSeller() {
    log.i('Streaming Item List');
    return firestore
        .collection('items')
        .orderBy('end_date')
        //.where('seller_id', isEqualTo: user.userID)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Item.fromJson(item.data());
      }).toList();
    });
  }

  Stream<List<Item>> getItemsForBidder() {
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
