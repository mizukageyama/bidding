import 'package:bidding/main/seller/controllers/auctioned_items_controller.dart';
import 'package:bidding/main/seller/controllers/sold_items_controller.dart';
import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/auth_controller.dart';
import 'package:bidding/shared/controllers/notif_controller.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class SellerSideMenuController extends GetxController {
  static final AuthController _authController = Get.find();
  final UserModel user = _authController.userModel.value!;
  final RxString activeMenu = 'Dashboard'.obs;

  final AuctionedItemController itemListController =
      Get.put(AuctionedItemController(), permanent: true);
  final SoldItemsController soldItemsController =
      Get.put(SoldItemsController(), permanent: true);
  final NotifController notifController =
      Get.put(NotifController(), permanent: true);

  @override
  void dispose() {
    Get.delete<SellerSideMenuController>(force: true);
    Get.delete<AuctionedItemController>(force: true);
    Get.delete<SoldItemsController>(force: true);
    Get.delete<NotifController>(force: true);
    super.dispose();
  }

  get userName => '${user.firstName} ${user.lastName}';

  get initials => '${user.firstName[0]}${user.lastName[0]}';

  String userProfile() {
    return _authController.info.value?.profilePhoto ?? '';
  }

  void reset() {
    activeMenu.value = 'Dashboard';
  }

  void changeActiveItem(String item) {
    activeMenu.value = item;
  }

  Color activeColor(String item, bool isHovered) {
    if (item == activeMenu.value) {
      return orangeColor;
    } else if (isHovered) {
      return greyColor;
    }
    return indigoColor;
  }
}
