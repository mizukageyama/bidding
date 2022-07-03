import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                          style: robotoRegular.copyWith(fontSize: 14),
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Seller: Yor forger.  ',
                                style: robotoBold),
                            TextSpan(
                              text: 'Item: ',
                            ),
                            TextSpan(
                              text: 'Scientific Calculator',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            )
                          ])),
                      Text.rich(TextSpan(
                          style: robotoRegular.copyWith(fontSize: 14),
                          children: const <TextSpan>[
                            TextSpan(text: 'Your Bid  '),
                            TextSpan(text: 'Php 200', style: robotoBold),
                            TextSpan(
                              text: ' has been approved by the Seller.',
                            )
                          ])),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                          'Please monitor your bids so that you will be updated with the new asking price.\nThank You.'),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '2 days ago.',
                        style: robotoRegular.copyWith(color: greyColor),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
