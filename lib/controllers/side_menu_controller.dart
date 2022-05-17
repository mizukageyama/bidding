import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class SideMenucontroller extends GetxController {
  // static final AuthController _authController = Get.find();
  // final UserModel user = _authController.userModel.value!;
  final RxString activeMenu = 'Dashboard'.obs;

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
