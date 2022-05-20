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
    function: () => Get.to(() => const SellerHome()),
  ),
  MenuItem(
    name: 'Auctioned Items',
    iconPath: 'icons/icon_raise.png',
    function: () => Get.to(() => const ItemListScreen()),
  ),
  MenuItem(
    name: 'Add Item for Auction',
    icon: Icons.add_rounded,
    function: () => Get.to(() => const AddItemForm()),
  ),
  MenuItem(
    name: 'Sold Items',
    iconPath: 'icons/icon_auction.png',
    function: () => Get.to(() => const SoldItemList()),
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
  Category(value: 'Electronic & Computers'),
  Category(value: 'Mobile Phones'),
  Category(value: 'Books'),
  Category(value: 'Supplies'),
  Category(value: 'Bags'),
  Category(value: 'Arts & Crafts'),
  Category(value: 'Jewelries & Accessories'),
  Category(value: 'Mens Clothing & Shoes'),
  Category(value: 'Womens Clothing & Shoes'),
  Category(value: 'Jewelries & Accessories'),
  Category(value: 'Video Games'),
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
