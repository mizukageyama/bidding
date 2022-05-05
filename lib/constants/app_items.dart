import 'package:bidding/models/menu_model.dart';
import 'package:bidding/screens/seller/home.dart';

List<MenuItem> sellerSideMenuItem = [
  MenuItem('Dashboard', SellerHome()),
  MenuItem('Actioned Items', SellerHome()),
  MenuItem('Add Item for Sale', SellerHome()),
  MenuItem('Sold Items', SellerHome()),
  MenuItem('Settings', SellerHome()),
  MenuItem('Logout', SellerHome()),
];
