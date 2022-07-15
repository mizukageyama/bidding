import 'package:bidding/components/info_display.dart';
import 'package:bidding/components/notification_card.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/notif_controller.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationFeed extends StatelessWidget {
  NotificationFeed({Key? key}) : super(key: key);
  final NotifController notifController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maroonColor,
      ),
      body: Obx(
        () => showNotification(),
      ),
    );
  }

  Widget showNotification() {
    if (notifController.isDoneLoading.value &&
        notifController.notifs.isNotEmpty) {
      return ListView.builder(
        itemCount: notifController.notifs.length,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(kIsWeb ? 10 : 10),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return NotificationCard(
            notif: notifController.notifs[index],
          );
        },
      );
    } else if (notifController.isDoneLoading.value &&
        notifController.notifs.isEmpty) {
      return const Center(
        child: InfoDisplay(message: 'You have no notifications'),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: maroonColor,
        ),
      ),
    );
  }
}
