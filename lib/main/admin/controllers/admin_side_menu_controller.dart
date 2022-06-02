import 'package:bidding/main/admin/controllers/closed_auction_controller.dart';
import 'package:bidding/main/admin/controllers/open_auction_controller.dart';
import 'package:bidding/main/admin/controllers/sold_auction_controller.dart';
import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class AdminSideMenuController extends GetxController {
  static final AuthController _authController = Get.find();
  final UserModel user = _authController.userModel.value!;
  final RxString activeMenu = 'Dashboard'.obs;

  final OpenAuctionController _openAuction =
      Get.put(OpenAuctionController(), permanent: true);
  final ClosedAuctionController _closedAuction =
      Get.put(ClosedAuctionController(), permanent: true);
  final SoldAuctionController _soldAuction =
      Get.put(SoldAuctionController(), permanent: true);

  @override
  void dispose() {
    Get.delete<AdminSideMenuController>(force: true);
    Get.delete<OpenAuctionController>(force: true);
    Get.delete<ClosedAuctionController>(force: true);
    Get.delete<SoldAuctionController>(force: true);
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
