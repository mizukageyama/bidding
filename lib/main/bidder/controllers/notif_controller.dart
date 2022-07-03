// import 'package:bidding/models/_models.dart';
// import 'package:bidding/shared/_packages_imports.dart';
// import 'package:bidding/shared/constants/_firebase_imports.dart';
// import 'package:bidding/shared/constants/firebase.dart';
// import 'package:bidding/shared/services/logger_service.dart';

// class NotifController extends GetxController {
//   final log = getLogger('Notification Controller');

//   RxList<NotificationModel> notif = RxList<NotificationModel>([]);

//   @override
//   void onReady() {
//     super.onReady();
//     notif.bindStream(assignListStream());
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications() {
//     log.i('Get Notifications');
//     return firestore
//         .collection('user')
//         .doc(auth.currentUser!.uid)
//         .collection('notifications')
//         .orderBy('createdAt', descending: true)
//         .snapshots(includeMetadataChanges: true);
//   }

//   Stream<List<NotificationModel>> assignListStream() {
//     return getNotifications().map(
//       (query) => query.docs
//           .map((item) => NotificationModel.fromJson(item.data()))
//           .toList(),
//     );
//   }
// }
