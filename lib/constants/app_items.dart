import 'package:bidding/models/menu_model.dart';
import 'package:bidding/screens/seller/home.dart';
import 'package:bidding/screens/seller/add_item_form.dart';

List<MenuItem> sellerSideMenuItem = [
  MenuItem('Dashboard', SellerHome()),
  MenuItem('Actioned Items', SellerHome()),
  MenuItem('Add Item for Sale', AddItemForm()),
  MenuItem('Sold Items', SellerHome()),
  MenuItem('Settings', SellerHome()),
  MenuItem('Logout', SellerHome()),
];
