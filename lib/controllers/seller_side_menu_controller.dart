import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/controllers/sold_items_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class SellerSideMenuController extends GetxController {
  // static final AuthController _authController = Get.find();
  // final UserModel user = _authController.userModel.value!;
  final RxString activeMenu = 'Dashboard'.obs;

  final ItemListController itemListController =
      Get.put(ItemListController(), permanent: true);
  final SoldItemsController soldItemsController =
      Get.put(SoldItemsController(), permanent: true);

  @override
  void dispose() {
    Get.delete<SellerSideMenuController>(force: true);
    Get.delete<ItemListController>(force: true);
    Get.delete<SoldItemsController>(force: true);
    super.dispose();
  }

  // String userName() {
  //   return '${user.firstName} ${user.lastName}';
  // }

  // String userRole() {
  //   return user.userRole;
  // }

  // String userProfile(){
  //   return user.;
  // }

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
