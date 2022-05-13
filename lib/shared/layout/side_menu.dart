import 'package:bidding/controllers/side_menu_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/components/side_menu_item_list.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  SideMenu(this.menuItems, {Key? key}) : super(key: key);
  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<MenuItem> menuItems;
  final SideMenucontroller menucontroller =
      Get.put(SideMenucontroller(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  const CircleImage(
                    imageUrl: '',
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
                          //menucontroller.userName(),
                          'Jesicca Day',
                          style: robotoMedium.copyWith(
                            color: whiteColor,
                            fontSize: 13,
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
                            //menucontroller.userRole().toUpperCase(),
                            'SELLER',
                            style: robotoMedium.copyWith(
                              color: whiteColor,
                              fontSize: 11,
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
            SideMenuItemList(itemList: menuItems),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
