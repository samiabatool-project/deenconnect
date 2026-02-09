import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateService {
  /// Gregorian Date (e.g. Monday, 27 Jan)
  static String getTodayDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMM').format(now);
  }

  /// Hijri Date (e.g. 15 Rajab 1447 AH)
  static String getHijriDate() {
    final hijri = HijriCalendar.now();

    return '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH';
  }
}
