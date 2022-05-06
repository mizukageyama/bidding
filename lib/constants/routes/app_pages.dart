import 'package:bidding/screens/auth/login.dart';
import 'package:bidding/screens/auth/signup.dart';
import 'package:bidding/screens/seller/add_item_form.dart';
import 'package:bidding/screens/seller/home.dart';
import 'package:bidding/screens/splash.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //Note: Set sa initial screen na atong gusto itest
  static const INITIAL = Routes.SPLASH;

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
  ];
}
