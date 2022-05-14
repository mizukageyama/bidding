import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/models/menu_model.dart';
import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:flutter/material.dart';

final AuthController authController = Get.find();

List<MenuItem> sellerSideMenuItem = [
  MenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    function: () => Get.to(() => const SellerHome()),
  ),
  MenuItem(
    name: 'Auctioned Items',
    iconPath: 'icons/icon_raise.png',
    function: () => Get.to(() => const ItemListScreen()),
  ),
  MenuItem(
    name: 'Add Item for Sale',
    icon: Icons.add_rounded,
    function: () => Get.to(() => const AddItemForm()),
  ),
  MenuItem(
    name: 'Sold Items',
    iconPath: 'icons/icon_auction.png',
    function: () => Get.to(() => const SellerHome()),
  ),
  MenuItem(
    name: 'Settings',
    icon: Icons.settings,
    function: () => Get.to(() => const SellerHome()),
  ),
  MenuItem(
    name: 'Logout',
    icon: Icons.logout,
    function: () => authController.signOut(),
  ),
];

//Note:
//List<String> for dp items
//readable and easy to understand variable names
final List<String> usertype = [
  'Seller',
  'Bidder',
];

final List<String> category = [
  'Electronics',
  'Things',
];

final List<String> condition = [
  'New',
  'Used - Like New',
  'Used - Good',
  'Used - Fair'
];
