import 'package:bidding/main/_auth/_auth_screens.dart';
import 'package:bidding/main/admin/screens/closed_auctions.dart';
import 'package:bidding/main/admin/screens/open_auctions.dart';
import 'package:bidding/main/admin/screens/sold_auctions.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/main/seller/screens/sold_item_list.dart';
import 'package:bidding/main/splash.dart';
import 'package:bidding/shared/_packages_imports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  //Note: Set sa initial screen na atong gusto itest
  static const iNITIAL = Routes.CLOSED_AUCTIONS;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),

    //Auth
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupScreen(),
    ),

    //Seller
    GetPage(
      name: _Paths.SELLER_HOME,
      page: () => const SellerHome(),
    ),
    GetPage(
      name: _Paths.ADD_ITEM_FORM,
      page: () => const AddItemForm(),
    ),
    GetPage(
      name: _Paths.ITEM_LIST,
      page: () => const AuctionedItemListScreen(),
    ),
    GetPage(
      name: _Paths.SOLD_ITEM_LIST,
      page: () => const SoldItemList(),
    ),

    //Admin
    GetPage(
      name: _Paths.OPEN_AUCTIONS,
      page: () => const OpenAuctionScreen(),
    ),
    GetPage(
      name: _Paths.CLOSED_AUCTIONS,
      page: () => const ClosedAuctionScreen(),
    ),
    GetPage(
      name: _Paths.SOLD_AUCTIONS,
      page: () => const SoldAuctionScreen(),
    )
  ];
}
