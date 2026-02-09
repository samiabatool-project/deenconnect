import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal() {
    tz.initializeTimeZones();
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification channels IDs
  static const String _prayerChannelId = 'prayer_channel';
  static const String _tasbeehChannelId = 'daily_tasbeeh_channel';
  static const String _quranChannelId = 'quran_channel';
  static const String _streakChannelId = 'streak_channel';
  static const String _duaChannelId = 'dua_channel';
  static const String _generalChannelId = 'general_channel';

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create all notification channels
    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel prayerChannel = AndroidNotificationChannel(
      _prayerChannelId,
      'نماز کی یاد دہانی',
      description: 'نماز کے اوقات کی نوٹیفکیشنز',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
      enableVibration: true,
    );

    const AndroidNotificationChannel tasbeehChannel =
        AndroidNotificationChannel(
      _tasbeehChannelId,
      'تسبیح یاد دہانی',
      description: 'روزانہ ذکر کی یاد دہانی',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const AndroidNotificationChannel quranChannel = AndroidNotificationChannel(
      _quranChannelId,
      'قرآن پاک',
      description: 'قرآن پاک کی تلاوت کی یاد دہانی',
      importance: Importance.high,
    );

    const AndroidNotificationChannel streakChannel = AndroidNotificationChannel(
      _streakChannelId,
      'اسٹرک اپ ڈیٹ',
      description: 'آپ کے اسٹرک کی معلومات',
      importance: Importance.defaultImportance,
    );

    const AndroidNotificationChannel duaChannel = AndroidNotificationChannel(
      _duaChannelId,
      'دعائیں',
      description: 'روزانہ دعاؤں کی یاد دہانی',
      importance: Importance.high,
    );

    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
      _generalChannelId,
      'عام نوٹیفکیشنز',
      description: 'دیگر تمام نوٹیفکیشنز',
      importance: Importance.defaultImportance,
    );

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(prayerChannel);
    await androidPlugin?.createNotificationChannel(tasbeehChannel);
    await androidPlugin?.createNotificationChannel(quranChannel);
    await androidPlugin?.createNotificationChannel(streakChannel);
    await androidPlugin?.createNotificationChannel(duaChannel);
    await androidPlugin?.createNotificationChannel(generalChannel);
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    // Handle notification tap
    final payload = notificationResponse.payload;
    if (payload != null) {
      // Navigate to specific screen based on payload
      print('Notification tapped with payload: $payload');
    }
  }

  // Prayer Time Notifications
  Future<void> schedulePrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    int id = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('prayer_notifications') ?? true;
    final soundEnabled = prefs.getBool('prayer_sound') ?? true;
    final vibrationEnabled = prefs.getBool('prayer_vibration') ?? true;

    if (!notificationsEnabled) return;

    await _notificationsPlugin.zonedSchedule(
      id,
      'نماز کا وقت',
      '$prayerName کی نماز کا وقت ہو گیا ہے',
      tz.TZDateTime.from(prayerTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _prayerChannelId,
          'نماز کی یاد دہانی',
          channelDescription: 'نماز کے اوقات کی نوٹیفکیشنز',
          importance: Importance.max,
          priority: Priority.high,
          sound: soundEnabled
              ? const RawResourceAndroidNotificationSound('adhan')
              : null,
          playSound: soundEnabled,
          enableVibration: vibrationEnabled,
          vibrationPattern:
              vibrationEnabled ? Int64List.fromList([0, 500, 500, 500]) : null,
          icon: '@mipmap/ic_launcher',
          color: Colors.green,
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: BigTextStyleInformation(
            'اللہ اکبر اللہ اکبر\nلا الہ الا اللہ\nاللہ اکبر اللہ اکبر\nوللہ الحمد',
            contentTitle: '$prayerName کا وقت',
            htmlFormatBigText: true,
            summaryText: 'نماز کی تیاری کریں',
          ),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'prayer_$prayerName',
    );
  }

  // Schedule all daily prayers
  Future<void> scheduleAllPrayerTimes(Map<String, DateTime> prayerTimes) async {
    await cancelAllPrayerNotifications();

    int id = 100; // Start ID for prayer notifications
    for (var entry in prayerTimes.entries) {
      await schedulePrayerTimeNotification(
        prayerName: entry.key,
        prayerTime: entry.value,
        id: id++,
      );
    }
  }

  // Cancel only prayer notifications
  Future<void> cancelAllPrayerNotifications() async {
    for (int i = 100; i < 150; i++) {
      await cancelNotification(i);
    }
  }

  // Daily Quran Reminder
  Future<void> scheduleDailyQuranReminder(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final quranRemindersEnabled = prefs.getBool('quran_reminders') ?? true;

    if (!quranRemindersEnabled) return;

    await _notificationsPlugin.zonedSchedule(
      200,
      'قرآن پاک کی تلاوت',
      'آج قرآن پاک کی تلاوت کریں اور ثواب حاصل کریں',
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _quranChannelId,
          'قرآن پاک',
          channelDescription: 'قرآن پاک کی تلاوت کی یاد دہانی',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            'آج کم از کم ایک رکوع قرآن پاک کی تلاوت ضرور کریں۔\n'
            'رسول اللہ ﷺ نے فرمایا: "تم میں سے بہتر وہ ہے جو قرآن سیکھے اور سکھائے۔"',
            contentTitle: 'قرآن پاک کی تلاوت',
            htmlFormatBigText: true,
          ),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'quran_reminder',
    );
  }

  // Daily Dua Reminder
  Future<void> scheduleDailyDuaReminder(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final duaRemindersEnabled = prefs.getBool('dua_reminders') ?? true;

    if (!duaRemindersEnabled) return;

    await _notificationsPlugin.zonedSchedule(
      300,
      'آج کی دعا',
      _getDailyDua(),
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _duaChannelId,
          'دعائیں',
          channelDescription: 'روزانہ دعاؤں کی یاد دہانی',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            '',
            contentTitle: 'آج کی دعا',
            htmlFormatBigText: true,
          ),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_dua',
    );
  }

  String _getDailyDua() {
    final duas = [
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلاً مُتَقَبَّلاً',
      'رَبِّ زِدْنِي عِلْمًا',
      'اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ، عَلَيْكَ تَوَكَّلْتُ، وَأَنْتَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
    ];
    final now = DateTime.now();
    return duas[now.day % duas.length];
  }

  // Existing methods with improvements
  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final tasbeehRemindersEnabled = prefs.getBool('tasbeeh_reminders') ?? true;

    if (!tasbeehRemindersEnabled) return;

    await _notificationsPlugin.zonedSchedule(
      0,
      'تسبیح وقت آگیا!',
      'اپنے روزانہ ذکر کا احتساب کریں',
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _tasbeehChannelId,
          'تسبیح یاد دہانی',
          channelDescription: 'روزانہ ذکر کی یاد دہانی',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            'آج کے ذکر: سبحان اللہ، الحمد للہ، اللہ اکبر\n'
            'ہر ذکر 33 بار پڑھیں اور اپنے روحانی اسٹرک کو جاری رکھیں۔',
            contentTitle: 'تسبیح وقت آگیا!',
            htmlFormatBigText: true,
          ),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_tasbeeh',
    );
  }

  Future<void> showStreakNotification(int streakDays) async {
    String title, message;

    if (streakDays == 1) {
      title = '🚀 نیا اسٹرک شروع!';
      message = 'آپ نے آج ذکر شروع کیا۔ جاری رکھیں!';
    } else if (streakDays == 7) {
      title = '🏆 پہلا ہفتہ مکمل!';
      message = 'مبارک ہو! آپ نے 7 دن کا اسٹرک مکمل کر لیا۔';
    } else if (streakDays % 30 == 0) {
      title = '🎯 $streakDays دن مکمل!';
      message = 'زبردست! آپ نے $streakDays دن مسلسل ذکر کیا۔';
    } else if (streakDays % 100 == 0) {
      title = '👑 $streakDays دن!';
      message = 'اللہ اکبر! آپ $streakDays دن سے مسلسل ذکر کر رہے ہیں۔';
    } else {
      title = '🔥 $streakDays دن مسلسل!';
      message = 'آپ $streakDays دن سے مسلسل ذکر کر رہے ہیں۔ جاری رکھیں!';
    }

    await _notificationsPlugin.show(
      1,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _streakChannelId,
          'اسٹرک اپ ڈیٹ',
          channelDescription: 'آپ کے اسٹرک کی معلومات',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'streak_$streakDays',
    );
  }

  // Check and update streak
  Future<void> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivity = prefs.getString('last_activity_date');
    final currentStreak = prefs.getInt('current_streak') ?? 0;

    final today = DateTime.now().toLocal();
    final todayFormatted = '${today.year}-${today.month}-${today.day}';

    if (lastActivity == todayFormatted) {
      return; // Already counted today
    }

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayFormatted =
        '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    int newStreak;
    if (lastActivity == yesterdayFormatted) {
      newStreak = currentStreak + 1;
    } else {
      newStreak = 1; // Streak broken
    }

    await prefs.setInt('current_streak', newStreak);
    await prefs.setString('last_activity_date', todayFormatted);

    // Show streak notification for milestones
    if (newStreak == 1 ||
        newStreak % 7 == 0 ||
        newStreak % 30 == 0 ||
        newStreak % 100 == 0) {
      await showStreakNotification(newStreak);
    }
  }

  // Show achievement notification
  Future<void> showAchievementNotification({
    required String title,
    required String description,
    String badgeName = '',
  }) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      '🏆 $title',
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _streakChannelId,
          'اسٹرک اپ ڈیٹ',
          channelDescription: 'آپ کے اسٹرک کی معلومات',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            '',
            contentTitle: 'انعام حاصل ہوا!',
            htmlFormatBigText: true,
          ),
        ),
      ),
      payload: 'achievement_$badgeName',
    );
  }

  // Simple notification with more options
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    int id = 0,
    String? payload,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _generalChannelId,
          'عام نوٹیفکیشنز',
          channelDescription: 'دیگر تمام نوٹیفکیشنز',
          importance: importance,
          priority: priority,
        ),
      ),
      payload: payload,
    );
  }

  // Get all scheduled notifications
  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Check notification permission
  Future<bool> checkNotificationPermission() async {
    final iosPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    final result = await iosPlugin?.checkPermissions();

    if (result == null) return true; // Android / null case

    // iOS permission check (alert is enough usually)
    return result.isEnabled ?? false;
  }

  // Request notification permission
  Future<bool> requestNotificationPermission() async {
    final iosPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    final result = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return result ?? true; // iOS: true/false, Android: true default
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Helper method to get notification preferences
  Future<Map<String, bool>> getNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'prayer_notifications': prefs.getBool('prayer_notifications') ?? true,
      'tasbeeh_reminders': prefs.getBool('tasbeeh_reminders') ?? true,
      'quran_reminders': prefs.getBool('quran_reminders') ?? true,
      'dua_reminders': prefs.getBool('dua_reminders') ?? true,
      'prayer_sound': prefs.getBool('prayer_sound') ?? true,
      'prayer_vibration': prefs.getBool('prayer_vibration') ?? true,
    };
  }

  // Helper method to save notification preferences
  Future<void> saveNotificationPreferences(
      Map<String, bool> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in preferences.entries) {
      await prefs.setBool(entry.key, entry.value);
    }
  }
}
