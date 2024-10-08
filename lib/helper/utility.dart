import 'package:intl/intl.dart';

class Unility {
  static String datetimeFormatter(DateTime datetime) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(datetime);
    return formattedDate;
  }
}