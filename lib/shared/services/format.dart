import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/services/time_ago.dart';
import 'package:intl/intl.dart';

class Format {
  static String date(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dt)} (${DateFormat.jm().format(dt)})';
  }

  static String dateln(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dt)}\n(${DateFormat.jm().format(dt)})';
  }

  static String dateShort(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return DateFormat.yMMMd().format(dt);
  }

  static String dateTime(DateTime dt) {
    return '${DateFormat.yMMMMd().format(dt)} (${DateFormat.jm().format(dt)})';
  }

  static String timeAgo(Timestamp timestamp) {
    final dt = timestamp.toDate();
    final dateString = DateFormat('dd-MM-yyyy h:mma').format(dt);
    return TimeAgo.timeAgoSinceDate(dateString, dt);
  }

  static String amount(double amount) {
    NumberFormat f = NumberFormat("#,##0.00", "en_US");
    return f.format(amount);
  }

  static String amountShort(double amount) {
    NumberFormat f = NumberFormat("#,##0", "en_US");
    return f.format(amount);
  }
}
