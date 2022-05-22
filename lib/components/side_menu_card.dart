import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SideMenuCard extends StatelessWidget {
  SideMenuCard({Key? key, required this.menu, required this.menuController})
      : super(key: key);
  final MenuItem menu;
  final RxBool onHover = false.obs;
  final dynamic menuController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        menuController.changeActiveItem(menu.name);
        menu.function();
        if (menu.name == 'Logout') {
          menuController.reset();
          menuController.dispose();
        }
      },
      onHover: (value) => onHover.value = value,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: kIsWeb ? 10 : 15),
          color: menuController.activeColor(menu.name, onHover.value),
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
                      size: kIsWeb ? 16 : 20,
                    )
                  : Image.asset(
                      menu.iconPath,
                      height: kIsWeb ? 16 : 20,
                      width: kIsWeb ? 16 : 20,
                    ),
              const SizedBox(
                width: kIsWeb ? 10 : 15,
              ),
              Text(
                menu.name,
                style: const TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: kIsWeb ? 13 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
