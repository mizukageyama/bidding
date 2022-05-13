import 'package:bidding/models/menu_model.dart';
import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:flutter/material.dart';

List<MenuItem> sellerSideMenuItem = [
  MenuItem(
    name: 'Dashboard',
    icon: Icons.dashboard,
    screen: SellerHome(),
  ),
  MenuItem(
    name: 'Auctioned Items',
    iconPath: 'icons/icon_raise.png',
    screen: SellerHome(),
  ),
  MenuItem(
    name: 'Add Item for Sale',
    icon: Icons.add_rounded,
    screen: AddItemForm(),
  ),
  MenuItem(
    name: 'Sold Items',
    iconPath: 'icons/icon_auction.png',
    screen: SellerHome(),
  ),
  MenuItem(
    name: 'Settings',
    icon: Icons.settings,
    screen: SellerHome(),
  ),
  MenuItem(
    name: 'Logout',
    icon: Icons.logout,
    screen: SellerHome(),
  ),
];

//Note:
//List<String> for dp items
//readable and easy to understand variable names
final List<String> rbutton = [
  'Seller',
  'Bidder',
];
