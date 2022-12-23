// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const SELLER_HOME = _Paths.SELLER_HOME;
  static const ADD_ITEM_FORM = _Paths.ADD_ITEM_FORM;
  static const ITEM_LIST = _Paths.ITEM_LIST;
  static const ITEM_INFO = _Paths.ITEM_INFO;
  static const TERMS_AND_CONDITION = _Paths.TERMS_AND_CONDITION;
  static const SOLD_ITEM_LIST = _Paths.SOLD_ITEM_LIST;
  static const SOLD_ITEM_INFO = _Paths.SOLD_ITEM_INFO;
  static const PROFILE = _Paths.PROFILE;
  static const OPEN_AUCTIONS = _Paths.OPEN_AUCTIONS;
  static const CLOSED_AUCTIONS = _Paths.CLOSED_AUCTIONS;
  static const SOLD_AUCTIONS = _Paths.SOLD_AUCTIONS;
  static const OPEN_TEST = _Paths.OPEN_TEST;
}

abstract class _Paths {
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const SELLER_HOME = '/seller-home';
  static const ADD_ITEM_FORM = '/add-item';
  static const ITEM_LIST = '/item-list';
  static const ITEM_INFO = '/item-info';
  static const TERMS_AND_CONDITION = '/terms-and-condition';
  static const SOLD_ITEM_LIST = '/sold-item-list';
  static const SOLD_ITEM_INFO = '/sold-item-info';
  static const PROFILE = '/profile';
  static const OPEN_AUCTIONS = '/open_auctions';
  static const CLOSED_AUCTIONS = '/closed_auctions';
  static const SOLD_AUCTIONS = '/sold_auctions';
  static const OPEN_TEST = '/open_test';
}
