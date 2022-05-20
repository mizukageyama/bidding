// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = '/';
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const SELLER_HOME = _Paths.SELLER_HOME;
  static const ADD_ITEM_FORM = _Paths.ADD_ITEM_FORM;
  static const ITEM_LIST = _Paths.ITEM_LIST;
  static const ITEM_INFO = _Paths.ITEM_INFO;
  static const TERMS_AND_CONDITION = _Paths.TERMS_AND_CONDITION;
  static const SOLD_ITEM_LIST = _Paths.SOLD_ITEM_LIST;
  static const SOLD_ITEM_INFO = _Paths.SOLD_ITEM_INFO;
}

abstract class _Paths {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const SELLER_HOME = '/seller-home';
  static const ADD_ITEM_FORM = '/add-item';
  static const ITEM_LIST = '/item-list';
  static const ITEM_INFO = '/item-info';
  static const TERMS_AND_CONDITION = '/terms-and-condition';
  static const SOLD_ITEM_LIST = '/sold-item-list';
  static const SOLD_ITEM_INFO = '/sold-item-info';
}
