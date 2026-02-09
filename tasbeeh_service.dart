import 'package:shared_preferences/shared_preferences.dart';

class TasbeehService {
  // 1. Counter Save karna (Counter Screen ke liye)
  static Future<void> saveCount(String name, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('count_$name', count);
    await _updateStreak(); // Har tasbeeh par streak update check karega
  }

  // 2. Counter Load karna (Counter Screen ke liye)
  static Future<int> getCount(String name, int defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('count_$name') ?? defaultValue;
  }

  // 3. Streak Logic (Dashboard ke liye)
  static Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD
    String lastDate = prefs.getString('last_date') ?? "";

    if (lastDate != today) {
      int currentStreak = prefs.getInt('streak_count') ?? 0;

      // Agar kal parhi thi toh streak barhao, warna reset
      DateTime lastDateTime =
          lastDate.isEmpty ? DateTime.now() : DateTime.parse(lastDate);
      if (DateTime.now().difference(lastDateTime).inDays == 1) {
        await prefs.setInt('streak_count', currentStreak + 1);
      } else if (lastDate.isEmpty) {
        await prefs.setInt('streak_count', 1);
      }

      await prefs.setString('last_date', today);
    }
  }

  // 4. Dashboard ke liye Streaks aur Total lena
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('streak_count') ?? 0;
  }
}
