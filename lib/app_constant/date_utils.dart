import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormat = DateFormat("dd/MM/yyyy, E");

  static String getFormattedDateFromMilli(int milliSeconds) {
    var date = DateTime.fromMillisecondsSinceEpoch(milliSeconds);
    return getFormattedDateFromDateTime(date);
  }

  static String getFormattedDateFromDateTime(DateTime dateTime) {
    var formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }
}
