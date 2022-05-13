import 'package:bidding/screens/auth/_auth_screens.dart';
import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/screens/splash.dart';
import 'package:bidding/shared/_packages_imports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  //Note: Set sa initial screen na atong gusto itest
  static const INITIAL = Routes.LOGIN;

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
    GetPage(
      name: _Paths.SELLER_HOME,
      page: () => SellerHome(),
    ),
    GetPage(
      name: _Paths.ADD_ITEM_FORM,
      page: () => AddItemForm(),
    ),
    GetPage(
      name: _Paths.ITEM_LIST,
      page: () => ItemListScreen(),
    ),
  ];
}
