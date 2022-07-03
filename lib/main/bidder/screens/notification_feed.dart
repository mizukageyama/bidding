import 'package:bidding/components/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationFeed extends StatelessWidget {
  const NotificationFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return NotificationCard();
          },
        ),
      ),
    );
  }
}
