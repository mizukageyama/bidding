import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class AdminSideMenuController extends GetxController {
  static final AuthController _authController = Get.find();
  final UserModel user = _authController.userModel.value!;
  final RxString activeMenu = 'Dashboard'.obs;

  @override
  void dispose() {
    Get.delete<AdminSideMenuController>(force: true);
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
