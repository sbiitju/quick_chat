import 'package:intl/intl.dart';

extension StringToDateExtension on String {
  DateTime toDate({String format = 'MM/dd/yyyy'}) {
    return DateFormat(format).parse(this);
  }

  DateTime toDateTime({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).parse(this);
  }
}

extension DateTimeExtension on DateTime {
  String formatToString({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(this);
  }

  static DateTime fromJson(String dateTime) {
    return DateTime.parse(dateTime).toLocal();
  }

  String toJson(DateTime dateTime) {
    return dateTime.toUtc().toString();
  }
}
