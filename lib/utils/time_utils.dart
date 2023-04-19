import 'package:intl/intl.dart';

class TimeUtils {
  static String getTime(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }
}

class TimeUtils2 {
  static String getTime(DateTime dateTime, {String format = 'MM-dd'}) {
    return DateFormat(format).format(dateTime);
  }
}
