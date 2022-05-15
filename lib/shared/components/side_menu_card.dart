import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SideMenuCard extends StatelessWidget {
  SideMenuCard({Key? key, required this.menu}) : super(key: key);
  final MenuItem menu;
  final RxBool onHover = false.obs;

  final SideMenucontroller menucontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        menucontroller.changeActiveItem(menu.name);
        menu.function();
        if (menu.name == 'Logout') {
          menucontroller.reset();
        }
      },
      onHover: (value) => onHover.value = value,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: menucontroller.activeColor(menu.name, onHover.value),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 20,
              ),
              menu.iconPath == ''
                  ? Icon(
                      menu.icon,
                      color: whiteColor,
                      size: 16,
                    )
                  : Image.asset(
                      menu.iconPath,
                      height: 16,
                      width: 16,
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(
                menu.name,
                style: const TextStyle(
                    color: whiteColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
