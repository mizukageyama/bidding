import 'package:bidding/models/notif_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key, required this.notif}) : super(key: key);
  final NotificationModel notif;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            notif.title,
            style: robotoBold,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            notif.message,
            style: robotoRegular,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            Format.timeAgo(notif.createdAt),
            style: robotoRegular.copyWith(color: greyColor),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }
}
