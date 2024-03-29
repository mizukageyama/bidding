import 'package:bidding/main/admin/screens/closed_auctions.dart';
import 'package:bidding/main/admin/screens/home.dart';
import 'package:bidding/main/admin/screens/open_auctions.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/main/admin/screens/sold_auctions.dart';
import 'package:bidding/main/bidder/screens/_bidder_screens.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/main/seller/screens/sold_item_list.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/models/category_model.dart';
import 'package:bidding/models/menu_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:flutter/material.dart';

final AuthController authController = Get.find();

//Seller Side Menu Options
List<SMenuItem> sellerSideMenuItem = [
  SMenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    function: () => Get.offAll(() => const SellerHome()),
  ),
  SMenuItem(
    name: 'Auctioned Items',
    iconPath: 'assets/icons/icon_raise.png',
    function: () => Get.offAll(() => const AuctionedItemListScreen()),
  ),
  SMenuItem(
    name: 'Add Item for Auction',
    icon: Icons.add_rounded,
    function: () => Get.offAll(() => const AddItemForm()),
  ),
  SMenuItem(
    name: 'Sold Items',
    iconPath: 'assets/icons/icon_auction.png',
    function: () => Get.offAll(() => const SoldItemList()),
  ),
  SMenuItem(
    name: 'My Profile',
    icon: Icons.settings,
    function: () => Get.offAll(
      () => ProfileScreen(
        sideMenu: SellerSideMenu(),
      ),
    ),
  ),
  SMenuItem(
    name: 'Logout',
    icon: Icons.logout,
    function: () => authController.signOut(),
  ),
];

//Bidder Side Menu Options
List<SMenuItem> bidderSideMenuItem = [
  SMenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    function: () => Get.offAll(() => const BidderHome()),
  ),
  SMenuItem(
    name: 'Ongoing Auctions',
    iconPath: 'assets/icons/icon_raise.png',
    function: () => Get.offAll(() => const OngoingAuctionScreen()),
  ),
  SMenuItem(
    name: 'Transactions',
    icon: Icons.add_rounded,
    function: () => Get.offAll(() => const TransactionScreen()),
  ),
  SMenuItem(
    name: 'My Profile',
    icon: Icons.settings,
    function: () => Get.offAll(
      () => ProfileScreen(
        sideMenu: BidderSideMenu(),
      ),
    ),
  ),
  SMenuItem(
    name: 'Logout',
    icon: Icons.logout,
    function: () => authController.signOut(),
  ),
];

//Admin Side Menu Options
List<SMenuItem> adminSideMenuItem = [
  SMenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    function: () => Get.offAll(() => const AdminHome()),
  ),
  SMenuItem(
    name: 'Open Auctions',
    iconPath: 'assets/icons/icon_raise.png',
    function: () => Get.offAll(() => const OpenAuctionScreen()),
  ),
  SMenuItem(
    name: 'Closed Auctions',
    icon: Icons.close_rounded,
    function: () => Get.offAll(() => const ClosedAuctionScreen()),
  ),
  SMenuItem(
    name: 'Sold Auctions',
    iconPath: 'assets/icons/icon_auction.png',
    function: () => Get.offAll(() => const SoldAuctionScreen()),
  ),
  SMenuItem(
    name: 'My Profile',
    icon: Icons.settings,
    function: () => Get.offAll(
      () => ProfileScreen(
        sideMenu: AdminSideMenu(),
      ),
    ),
  ),
  SMenuItem(
    name: 'Logout',
    icon: Icons.logout,
    function: () => authController.signOut(),
  ),
];

//Registration Dropdown
final List<String> userType = [
  'Seller',
  'Bidder',
];

//Add Item for Auction
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
  Category(value: 'Video Games'),
  Category(value: 'Add Custom Category', isAdd: true),
];

final List<String> categorySearchOption = [
  'Electronics',
  'Electronic & Computers',
  'Mobile Phones',
  'Books',
  'Supplies',
  'Bags',
  'Arts & Crafts',
  'Jewelries & Accessories',
  'Mens Clothing & Shoes',
  'Video Games'
];

final List<String> condition = [
  'New',
  'Used - Like New',
  'Used - Good',
  'Used - Fair'
];
