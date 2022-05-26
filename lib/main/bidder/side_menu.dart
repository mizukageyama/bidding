import 'package:bidding/components/circle_image.dart';
import 'package:bidding/components/side_menu_card.dart';
import 'package:bidding/main/bidder/controllers/bidder_side_menu_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidderSideMenu extends StatelessWidget {
  BidderSideMenu({Key? key}) : super(key: key);
  final scrollController = ScrollController(initialScrollOffset: 0);
  final BidderSideMenuController menucontroller =
      Get.put(BidderSideMenuController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIsWeb && Get.width >= 600
          ? double.infinity
          : kIsWeb && Get.width <= 600
              ? Get.width * .45
              : Get.width * .65,
      height: Get.height,
      color: indigoColor,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children: [
                  Obx(
                    () => CircleImage(
                      imageUrl: menucontroller.userProfile(),
                      initial: menucontroller.initials,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menucontroller.userName,
                          style: robotoMedium.copyWith(
                            color: whiteColor,
                            fontSize: kIsWeb ? 13 : 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: orangeColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 3,
                          ),
                          child: Text(
                            'BIDDER',
                            style: robotoMedium.copyWith(
                              color: whiteColor,
                              fontSize: kIsWeb ? 11 : 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 45,
              width: 45,
            ),
            ...bidderSideMenuItem
                .map((item) => SideMenuCard(
                      menu: item,
                      menuController: menucontroller,
                    ))
                .toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
