import 'package:bidding/models/notif_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/controllers/auth_controller.dart';

class NotifController extends GetxController {
  final AuthController _authController = Get.find();
  final RxList<NotificationModel> notifs = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;

  @override
  void onInit() {
    notifs.clear();
    notifs.bindStream(getUserNotifs());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
    super.onInit();
  }

  get notifBadgeCount => _authController.info.value?.badgeCount ?? 0;

  Future<void> resetBadge() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('additional_info')
        .doc('value')
        .update({
      'notif_badge': 0,
    });
  }

  Stream<List<NotificationModel>> getUserNotifs() {
    print(auth.currentUser!.uid);
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return NotificationModel.fromJson(item.data());
      }).toList();
    });
  }
}
