import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';

// Notification Model
class PrayerNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final bool isEnabled;
  final NotificationType type;

  PrayerNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.isEnabled,
    required this.type,
  });

  PrayerNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? scheduledTime,
    bool? isEnabled,
    NotificationType? type,
  }) {
    return PrayerNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isEnabled: isEnabled ?? this.isEnabled,
      type: type ?? this.type,
    );
  }
}

enum NotificationType { prayer, dua, quran, tasbeeh, general }

// Notification Provider
class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<PrayerNotification> _notifications = [];
  bool _isInitialized = false;

  List<PrayerNotification> get notifications => _notifications;
  bool get isInitialized => _isInitialized;

  NotificationProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Initialize notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap
        },
      );

      // Load default notifications
      _loadDefaultNotifications();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _loadDefaultNotifications() {
    final now = DateTime.now();

    _notifications = [
      PrayerNotification(
        id: '1',
        title: 'Fajr Prayer',
        body: 'Time for Fajr prayer. May Allah accept your prayers.',
        scheduledTime: DateTime(now.year, now.month, now.day, 5, 30),
        isEnabled: true,
        type: NotificationType.prayer,
      ),
      PrayerNotification(
        id: '2',
        title: 'Dhuhr Prayer',
        body: 'Time for Dhuhr prayer. Remember to pray on time.',
        scheduledTime: DateTime(now.year, now.month, now.day, 12, 30),
        isEnabled: true,
        type: NotificationType.prayer,
      ),
      PrayerNotification(
        id: '3',
        title: 'Asr Prayer',
        body: 'Time for Asr prayer. Pray before the sun sets.',
        scheduledTime: DateTime(now.year, now.month, now.day, 15, 45),
        isEnabled: true,
        type: NotificationType.prayer,
      ),
      PrayerNotification(
        id: '4',
        title: 'Maghrib Prayer',
        body: 'Time for Maghrib prayer. Break your fast with prayer.',
        scheduledTime: DateTime(now.year, now.month, now.day, 18, 15),
        isEnabled: true,
        type: NotificationType.prayer,
      ),
      PrayerNotification(
        id: '5',
        title: 'Isha Prayer',
        body: 'Time for Isha prayer. Complete your day with prayer.',
        scheduledTime: DateTime(now.year, now.month, now.day, 19, 45),
        isEnabled: true,
        type: NotificationType.prayer,
      ),
      PrayerNotification(
        id: '6',
        title: 'Morning Dhikr',
        body: 'Start your day with the remembrance of Allah.',
        scheduledTime: DateTime(now.year, now.month, now.day, 7, 0),
        isEnabled: true,
        type: NotificationType.dua,
      ),
      PrayerNotification(
        id: '7',
        title: 'Evening Dhikr',
        body: 'End your day with the remembrance of Allah.',
        scheduledTime: DateTime(now.year, now.month, now.day, 18, 0),
        isEnabled: true,
        type: NotificationType.dua,
      ),
      PrayerNotification(
        id: '8',
        title: 'Quran Reading',
        body: 'Time for your daily Quran reading.',
        scheduledTime: DateTime(now.year, now.month, now.day, 8, 0),
        isEnabled: true,
        type: NotificationType.quran,
      ),
      PrayerNotification(
        id: '9',
        title: 'Tasbeeh Reminder',
        body: 'Complete your daily tasbeeh count.',
        scheduledTime: DateTime(now.year, now.month, now.day, 21, 0),
        isEnabled: true,
        type: NotificationType.tasbeeh,
      ),
    ];

    // Schedule all enabled notifications
    _scheduleAllNotifications();
  }

  Future<void> _scheduleAllNotifications() async {
    for (var notification in _notifications) {
      if (notification.isEnabled) {
        await _scheduleNotification(notification);
      }
    }
  }

  Future<void> _scheduleNotification(PrayerNotification notification) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Notifications',
        channelDescription: 'Notifications for prayer times and reminders',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('azan'),
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentSound: true,
        presentBadge: true,
        presentAlert: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      // Convert to local timezone
      final scheduledDate = tz.TZDateTime.from(
        notification.scheduledTime,
        tz.local,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(notification.id),
        notification.title,
        notification.body,
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> toggleNotification(String id, bool enabled) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] =
          _notifications[index].copyWith(isEnabled: enabled);

      if (enabled) {
        await _scheduleNotification(_notifications[index]);
      } else {
        await _flutterLocalNotificationsPlugin.cancel(int.parse(id));
      }

      notifyListeners();
    }
  }

  Future<void> updateNotificationTime(String id, TimeOfDay newTime) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final now = DateTime.now();
      final updatedTime = DateTime(
        now.year,
        now.month,
        now.day,
        newTime.hour,
        newTime.minute,
      );

      _notifications[index] = _notifications[index].copyWith(
        scheduledTime: updatedTime,
      );

      if (_notifications[index].isEnabled) {
        await _flutterLocalNotificationsPlugin.cancel(int.parse(id));
        await _scheduleNotification(_notifications[index]);
      }

      notifyListeners();
    }
  }

  Future<void> clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _notifications =
        _notifications.map((n) => n.copyWith(isEnabled: false)).toList();
    notifyListeners();
  }

  Future<void> enableAllNotifications() async {
    for (var notification in _notifications) {
      if (!notification.isEnabled) {
        await toggleNotification(notification.id, true);
      }
    }
  }

  Future<void> testNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification from Deen Connect',
      platformChannelSpecifics,
    );
  }
}

// Main Notifications Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Prayer', 'Dua', 'Quran', 'Tasbeeh'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (!provider.isInitialized) {
              return _buildLoadingScreen();
            }

            final filteredNotifications = _selectedFilter == 0
                ? provider.notifications
                : provider.notifications
                    .where((n) => n.type.index == _selectedFilter - 1)
                    .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 180,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2E7D32),
                            Color(0xFF4CAF50),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 100,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Manage your prayer reminders',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Filter Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              right: index < _filters.length - 1 ? 12 : 0,
                            ),
                            child: ChoiceChip(
                              label: Text(
                                _filters[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedFilter == index
                                      ? Colors.white
                                      : const Color(0xFF2E7D32),
                                ),
                              ),
                              selected: _selectedFilter == index,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = index;
                                });
                              },
                              selectedColor: const Color(0xFF2E7D32),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: _selectedFilter == index
                                      ? Colors.transparent
                                      : Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Notifications List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationCard(notification, provider);
                    },
                    childCount: filteredNotifications.length,
                  ),
                ),

                // Empty State
                if (filteredNotifications.isEmpty)
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No notifications',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add some notifications to get reminders',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final provider = Provider.of<NotificationProvider>(
              context,
              listen: false,
            );
            provider.enableAllNotifications();
          },
          icon: const Icon(Icons.notifications_active),
          label: const Text('Enable All'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 20),
          Text(
            'Setting up notifications...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      PrayerNotification notification, NotificationProvider provider) {
    final time = TimeOfDay.fromDateTime(notification.scheduledTime);
    final icon = _getNotificationIcon(notification.type);
    final color = _getNotificationColor(notification.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2), width: 1.5),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _getTypeColor(notification.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTypeLabel(notification.type),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _getTypeColor(notification.type),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Daily',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Toggle Switch
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: notification.isEnabled,
                onChanged: (value) {
                  provider.toggleNotification(notification.id, value);
                },
                activeThumbColor: const Color(0xFF2E7D32),
                activeTrackColor: const Color(0xFF2E7D32).withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return Icons.mosque;
      case NotificationType.dua:
        return Icons.handshake;
      case NotificationType.quran:
        return Icons.menu_book;
      case NotificationType.tasbeeh:
        return Icons.beach_access;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return const Color(0xFF2E7D32);
      case NotificationType.dua:
        return const Color(0xFF2196F3);
      case NotificationType.quran:
        return const Color(0xFFFF9800);
      case NotificationType.tasbeeh:
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF757575);
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return 'PRAYER';
      case NotificationType.dua:
        return 'DUA';
      case NotificationType.quran:
        return 'QURAN';
      case NotificationType.tasbeeh:
        return 'TASBEEH';
      default:
        return 'GENERAL';
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.prayer:
        return const Color(0xFF2E7D32);
      case NotificationType.dua:
        return const Color(0xFF2196F3);
      case NotificationType.quran:
        return const Color(0xFFFF9800);
      case NotificationType.tasbeeh:
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF757575);
    }
  }
}

// Notification Settings Screen
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // General Settings
              _buildSettingsSection(
                title: 'General Settings',
                children: [
                  _buildSettingSwitch(
                    title: 'Enable Notifications',
                    value: provider.notifications.any((n) => n.isEnabled),
                    onChanged: (value) {
                      if (value) {
                        provider.enableAllNotifications();
                      } else {
                        provider.clearAllNotifications();
                      }
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Vibration',
                    value: true,
                    onChanged: (value) {},
                  ),
                  _buildSettingSwitch(
                    title: 'Sound',
                    value: true,
                    onChanged: (value) {},
                  ),
                  _buildSettingSwitch(
                    title: 'LED Light',
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Prayer Notifications
              _buildSettingsSection(
                title: 'Prayer Notifications',
                children: [
                  _buildSettingSwitch(
                    title: 'Notify 5 minutes before',
                    value: true,
                    onChanged: (value) {},
                  ),
                  _buildSettingSwitch(
                    title: 'Notify at prayer time',
                    value: true,
                    onChanged: (value) {},
                  ),
                  _buildSettingSwitch(
                    title: 'Include Azan sound',
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Advanced Settings
              _buildSettingsSection(
                title: 'Advanced',
                children: [
                  _buildSettingButton(
                    title: 'Test Notification',
                    icon: Icons.notifications,
                    onTap: () {
                      provider.testNotification();
                    },
                  ),
                  _buildSettingButton(
                    title: 'Clear All Notifications',
                    icon: Icons.delete_outline,
                    onTap: () {
                      provider.clearAllNotifications();
                    },
                  ),
                  _buildSettingButton(
                    title: 'Reset to Default',
                    icon: Icons.restore,
                    onTap: () {
                      // Implement reset logic
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
