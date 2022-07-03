import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 10),
      width: Get.width * .4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: robotoBold.copyWith(
                color: blackColor, fontSize: kIsWeb ? 20 : 12),
          ),
          const SizedBox(height: 10),
          Text(
            'These terms and conditions outline the rules and regulators for the use of Bidding Online Application. By accessing this application, we assume you accept these terms and conditions. Do not continue to use this application if you do not agree to take all of the terms and conditions stated on this page. The following terminology applies to these Terms & Conditions, Privacy Policy and Disclaimer Notice and all Agreements: Bidding Online (“us”, “we”, or “our”) operates http://www.BiddingOnline.com. This page informs you of our terms & condition regarding the collection, use and disclosure of Personal Information we receive from users of the application.',
            textAlign: TextAlign.justify,
            style: robotoRegular.copyWith(
                color: blackColor, fontSize: kIsWeb ? 16 : 11),
          ),
          const SizedBox(height: 10),
          Text(
            'Privacy Policy',
            style: robotoBold.copyWith(
                color: blackColor, fontSize: kIsWeb ? 20 : 12),
          ),
          const SizedBox(height: 10),
          Text(
            'We use your Personal Information only for providing and improving the application. By using this application, you agree to the collection and use of information in accordance with this policy.',
            textAlign: TextAlign.justify,
            style: robotoRegular.copyWith(
                color: blackColor, fontSize: kIsWeb ? 16 : 11),
          ),
          const SizedBox(height: 10),
          Text(
            'Information Collection and Use',
            style: robotoBold.copyWith(
                color: blackColor, fontSize: kIsWeb ? 20 : 12),
          ),
          const SizedBox(height: 10),
          Text(
            'While using our application, we may ask you to provide us with certain personally identifiable information that can be used to contact or identified you. Personally identifiable information may include, but is not limited to your name ("Personal Information").',
            textAlign: TextAlign.justify,
            style: robotoRegular.copyWith(
                color: blackColor, fontSize: kIsWeb ? 16 : 11),
          ),
          const SizedBox(height: 10),
          Text(
            'Termination',
            style: robotoBold.copyWith(
                color: blackColor, fontSize: kIsWeb ? 20 : 12),
          ),
          const SizedBox(height: 10),
          Text(
            'We may terminate or suspend access to our Service Immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
            textAlign: TextAlign.justify,
            style: robotoRegular.copyWith(
                color: blackColor, fontSize: kIsWeb ? 16 : 11),
          ),
        ],
      ),
    );
  }
}
