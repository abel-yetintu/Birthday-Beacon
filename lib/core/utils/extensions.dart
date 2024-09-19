import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String getMonthAndDay() {
    return DateFormat.MMMd().format(this);
  }

  String getMonthDayYear() {
    return DateFormat.yMMMd().format(this);
  }

  String getFullMonth() {
    return DateFormat.LLLL().format(this);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
