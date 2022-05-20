import 'package:bidding/shared/constants/_firebase_imports.dart';

import 'package:intl/intl.dart';

class Format {
  static String date(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dt)} (${DateFormat.jm().format(dt)})';
  }

  static String amount(double amount) {
    NumberFormat f = NumberFormat("#,##0.00", "en_US");
    return f.format(amount);
  }
}
