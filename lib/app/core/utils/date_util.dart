import 'package:intl/intl.dart';

class AppDateUtil {
  static formatDate(DateTime date) => DateFormat.yMMMMd().format(date);
}
