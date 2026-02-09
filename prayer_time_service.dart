import 'package:adhan/adhan.dart';

class PrayerTimeService {
  static Map<String, String> getPrayerTimes(double latitude, double longitude) {
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.hanafi;

    final coordinates = Coordinates(latitude, longitude);

    final now = DateTime.now();
    final date = DateComponents(now.year, now.month, now.day);

    final prayerTimes = PrayerTimes(coordinates, date, params);

    String formatTime(DateTime time) {
      final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    return {
      'Fajr': formatTime(prayerTimes.fajr),
      'Dhuhr': formatTime(prayerTimes.dhuhr),
      'Asr': formatTime(prayerTimes.asr),
      'Maghrib': formatTime(prayerTimes.maghrib),
      'Isha': formatTime(prayerTimes.isha),
    };
  }
}
