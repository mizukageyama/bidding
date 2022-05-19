import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/menu_model.dart';
import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/screens/seller/sold_item_list.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:flutter/material.dart';

final AuthController authController = Get.find();

List<MenuItem> sellerSideMenuItem = [
  MenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    function: () => Get.offAll(() => const SellerHome()),
  ),
  MenuItem(
    name: 'Auctioned Items',
    iconPath: 'icons/icon_raise.png',
    function: () => Get.offAll(() => const ItemListScreen()),
  ),
  MenuItem(
    name: 'Add Item for Auction',
    icon: Icons.add_rounded,
    function: () => Get.offAll(() => const AddItemForm()),
  ),
  MenuItem(
    name: 'Sold Items',
    iconPath: 'icons/icon_auction.png',
    function: () => Get.offAll(() => const SoldItemList()),
  ),
  // MenuItem(
  //   name: 'Settings',
  //   icon: Icons.settings,
  //   function: () => Get.to(() => const SellerHome()),
  // ),
  MenuItem(
    name: 'Logout',
    icon: Icons.logout,
    function: () => authController.signOut(),
  ),
];

//Note:
//List<String> for dp items
//readable and easy to understand variable names
final List<String> userType = [
  'Seller',
  'Bidder',
];

final List<Category> category = [
  Category(value: 'Electronics'),
  Category(value: 'IT'),
  Category(value: 'Tools'),
  Category(value: 'Books'),
  Category(value: 'Supplies'),
  Category(value: 'Apparel'),
  Category(value: 'Others'),
  Category(value: 'Add Custom Category', isAdd: true),
];

final List<String> condition = [
  'New',
  'Used - Like New',
  'Used - Good',
  'Used - Fair'
];

class Category {
  bool isAdd;
  final String value;

  Category({required this.value, this.isAdd = false});
}
