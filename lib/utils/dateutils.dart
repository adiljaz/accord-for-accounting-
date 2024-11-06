import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat displayFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat apiFormat = DateFormat('yyyy-MM-dd');

  static String formatForDisplay(DateTime date) {
    return displayFormat.format(date);
  }

  static String formatForApi(DateTime date) {
    return apiFormat.format(date);
  }

  static DateTime? parseFromDisplay(String date) {
    try {
      return displayFormat.parse(date);
    } catch (e) {
      return null;
    }
  }
}
