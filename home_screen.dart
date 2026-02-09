import 'package:deen_connect/features/tasbeeh/tasbeeh_dashboard.dart';
import 'package:deen_connect/features/tasbeeh/add_tasbeeh_screen.dart';
import 'package:flutter/material.dart';
import 'package:deen_connect/features/prayer_times/prayer_times_screen.dart';
import 'package:deen_connect/features/qibla/qibla_screen.dart';
import 'package:deen_connect/features/quran/quran_screen.dart';
import 'package:deen_connect/features/duas/duas_screen.dart';
import 'package:deen_connect/features/tracker/tracker_screen.dart';
import 'package:deen_connect/features/settings/settings_screen.dart';
import 'package:deen_connect/features/notifications/notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_connect/services/tasbeeh_service.dart';
import 'package:deen_connect/services/tasbeeh_service.dart';
import 'package:deen_connect/services/location_service.dart';
import 'package:deen_connect/services/date_service.dart';
import 'package:deen_connect/services/prayer_time_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const PrayerTimesScreen(),
    const QiblaScreen(),
    const QuranScreen(),
    const DuasScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 193, 163),

      // Body
      body: _screens[_selectedIndex],

      // Bottom Navigation Bar - Dark Colors
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 41, 36), // Dark Brown
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_filled,
                  label: 'Home',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.access_time_outlined,
                  activeIcon: Icons.access_time_filled,
                  label: 'Prayer',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Qibla',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.book_outlined,
                  activeIcon: Icons.book,
                  label: 'Quran',
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Duas',
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrackerScreen(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF4A3728),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 8,
              child: const Icon(Icons.insights, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF4A3728),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A3728).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _city = 'Loading...';
  String _country = '';
  String _todayDate = '';
  String _hijriDate = '';
  Map<String, String>? _todayPrayerTimes;
  bool _loadingPrayerTimes = true;

  Future<void> _loadLocation() async {
    final data = await LocationService.getLocationData();

    if (!mounted) return;

    setState(() {
      _city = data['city'] ?? '';
      _country = data['country'] ?? '';
    });
  }

  void _loadDates() {
    setState(() {
      _todayDate = DateService.getTodayDate();
      _hijriDate = DateService.getHijriDate();
    });
  }

  void _updatePrayerList() {
    if (_todayPrayerTimes == null) return;

    final now = DateTime.now();

    prayers[0]['time'] = _todayPrayerTimes!['Fajr'];
    prayers[2]['time'] = _todayPrayerTimes!['Dhuhr'];
    prayers[3]['time'] = _todayPrayerTimes!['Asr'];
    prayers[4]['time'] = _todayPrayerTimes!['Maghrib'];
    prayers[5]['time'] = _todayPrayerTimes!['Isha'];

    // Reset flags
    for (var p in prayers) {
      p['passed'] = false;
      p.remove('next');
    }

    // Determine passed & next prayer
    for (int i = 0; i < prayers.length; i++) {
      final timeStr = prayers[i]['time'] as String;
      final time = _parseTime(timeStr);

      if (time.isBefore(now)) {
        prayers[i]['passed'] = true;
      } else {
        prayers[i]['next'] = true;
        break;
      }
    }
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(' ');
    final hm = parts[0].split(':');

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  List<Map<String, dynamic>> prayers = [
    {
      'name': 'Fajr',
      'time': '5:45 AM',
      'color': const Color.fromARGB(255, 85, 66, 44), // Green for Fajr
      'passed': true,
      'endedAgo': '2h 30m ago',
      'timeLeft': 'Completed',
      'icon': Icons.nightlight_round,
    },
    {
      'name': 'Sunrise',
      'time': '7:00 AM',
      'color': const Color.fromARGB(255, 82, 59, 37), // Orange for Sunrise
      'passed': true,
      'endedAgo': '1h 15m ago',
      'timeLeft': 'Completed',
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'Dhuhr',
      'time': '12:50 PM',
      'color': const Color.fromARGB(255, 83, 68, 45), // Blue for Dhuhr
      'passed': false,
      'timeLeft': '3h 5min',
      'next': true,
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'Asr',
      'time': '3:45 PM',
      'color': const Color.fromARGB(255, 87, 67, 46), // Purple for Asr
      'passed': false,
      'timeLeft': '5h 15m',
      'icon': Icons.access_time,
    },
    {
      'name': 'Maghrib',
      'time': '5:20 PM',
      'color': const Color.fromARGB(255, 87, 64, 38), // Red for Maghrib
      'passed': false,
      'timeLeft': '8h 30m',
      'icon': Icons.nightlight_round,
    },
    {
      'name': 'Isha',
      'time': '7:10 PM',
      'color': const Color.fromARGB(255, 44, 31, 21), // Dark Blue for Isha
      'passed': false,
      'timeLeft': '10h 00m',
      'icon': Icons.nightlight_round,
    },
  ];

  final List<Map<String, dynamic>> quickAccessItems = [
    {
      'icon': Icons.explore,
      'label': 'Qibla',
      'screen': 'qibla',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.psychology_alt,
      'label': 'Tasbeeh',
      'screen': 'tasbeeh',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.book,
      'label': 'Quran',
      'screen': 'quran',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.favorite,
      'label': 'Duas',
      'screen': 'duas',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.insights,
      'label': 'Tracker',
      'screen': 'tracker',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Calendar',
      'screen': 'calendar',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.book_online_sharp,
      'label': 'hadith',
      'screen': 'hadith',
      'color': const Color(0xFF4A3728),
    },
    {
      'icon': Icons.nature,
      'label': 'Names',
      'screen': 'names',
      'color': const Color(0xFF4A3728),
    },
  ];

  final List<Map<String, dynamic>> dailyReminders = [
    {
      'text':
          '"Whoever treads a path in search of knowledge, Allah will make easy for him the path to Paradise."',
      'source': 'Sahih Muslim',
      'type': 'Hadith',
    },
    {
      'text': '"Indeed, with hardship comes ease."',
      'source': 'Quran 94:6',
      'type': 'Quran',
    },
    {
      'text': '"The best of you are those who are best to their families."',
      'source': 'Sunan al-Tirmidhi',
      'type': 'Hadith',
    },
  ];

  // TASBEEH DATA
  List<Map<String, dynamic>> tasbeehList = [
    {
      'id': '1',
      'name': 'سُبْحَانَ اللَّهِ',
      'arabic': 'سُبْحَانَ اللَّهِ',
      'current': 0,
      'target': 100,
      'progress': 0,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'isDaily': true,
      'streak': 0,
    },
    {
      'id': '2',
      'name': 'الْحَمْدُ لِلَّهِ',
      'arabic': 'الْحَمْدُ لِلَّهِ',
      'current': 0,
      'target': 100,
      'progress': 0,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'isDaily': true,
      'streak': 0,
    },
    {
      'id': '3',
      'name': 'اللَّهُ أَكْبَرُ',
      'arabic': 'اللَّهُ أَكْبَرُ',
      'current': 0,
      'target': 100,
      'progress': 0,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'isDaily': true,
      'streak': 0,
    },
  ];

  final List<Map<String, dynamic>> badges = [
    {
      'name': 'Golden Praiser',
      'icon': Icons.emoji_events,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'earned': true,
    },
    {
      'name': 'continously 7 Days',
      'icon': Icons.local_fire_department,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'earned': true,
    },
    {
      'name': 'monthly champion',
      'icon': Icons.workspace_premium,
      'color': const Color.fromARGB(255, 65, 51, 32),
      'earned': false,
    },
    {
      'name': 'Praise whole night',
      'icon': Icons.nightlight_round,
      'color': const Color.fromARGB(255, 70, 56, 38),
      'earned': false,
    },
  ];

  int _currentReminderIndex = 0;
  int _currentTasbeehIndex = 0;
  int _dailyStreak = 0;

  int _totalTasbeehCount = 0;
  double _dailyProgress = 0;

  @override
  void initState() {
    super.initState();
    _currentReminderIndex = DateTime.now().day % dailyReminders.length;
    _currentTasbeehIndex = DateTime.now().hour % tasbeehList.length;
    _loadLocation();
    _loadDates();
    // App start hotay hi data load karo
    _loadTasbeehData();
  }

  void _loadPrayerTimes() {
    // 📍 TEMP: Pakistan location (later GPS se lena)
    const double lat = 31.4514; // Nankana Sahib
    const double lng = 73.7065;

    final times = PrayerTimeService.getPrayerTimes(lat, lng);

    setState(() {
      _todayPrayerTimes = times;
      _loadingPrayerTimes = false;
      _updatePrayerList();
    });
  }

  // --- BACKEND FUNCTION (Shared Preferences) ---
  Future<void> _loadTasbeehData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int totalCount = 0;

      List<Map<String, dynamic>> updatedList =
          List<Map<String, dynamic>>.from(tasbeehList);

      for (var item in updatedList) {
        int savedCount = prefs.getInt('count_${item['name']}') ?? 0;

        item['current'] = savedCount;

        double target = (item['target'] as num).toDouble();
        item['progress'] =
            target == 0 ? 0.0 : (savedCount / target).clamp(0.0, 1.0);

        totalCount += savedCount;
      }

      if (!mounted) return;

      setState(() {
        tasbeehList = updatedList;
        _totalTasbeehCount = totalCount;
        _dailyStreak = prefs.getInt('daily_streak') ?? 0;
        _dailyProgress = (totalCount / 300.0).clamp(0.0, 1.0);
      });
    } catch (e) {
      debugPrint('Tasbeeh Load Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = prayers.firstWhere((p) => p['next'] == true);
    final lastPrayer = prayers.lastWhere((p) => p['passed'] == true);
    final currentTasbeeh = tasbeehList[_currentTasbeehIndex];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header with Mosque PNG and Icons
        SliverAppBar(
          expandedHeight: 300,
          backgroundColor: const Color.fromARGB(255, 182, 157, 132),
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeader(),
          ),
          pinned: true,
          floating: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
              icon: const Badge(
                label: Text('3'),
                child: Icon(Icons.notifications,
                    color: Color(0xFF4A3728), size: 28),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings,
                  color: Color(0xFF4A3728), size: 28),
            ),
          ],
        ),

        // Content
        SliverList(
          delegate: SliverChildListDelegate([
            // Location, Date, Weather Card
            _buildLocationWeatherCard(),

            const SizedBox(height: 20),

            // Prayer Times Card - Updated Design
            _buildPrayerTimesCard(nextPrayer, lastPrayer),

            const SizedBox(height: 20),

            // تَسْبِيحْ Quick Preview - NEW DESIGN
            _buildTasbeehQuickPreview(currentTasbeeh),

            const SizedBox(height: 20),

            // Quick Access - Updated Design
            _buildQuickAccessSection(),

            const SizedBox(height: 20),

            // Daily Reminder with Design
            _buildDailyReminderCard(),

            const SizedBox(height: 20),

            // تَسْبِيحْ Progress & Badges Section - NEW
            _buildTasbeehProgressSection(),

            const SizedBox(height: 20),

            // Progress Section
            _buildProgressSection(),

            const SizedBox(height: 80),
          ]),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 165, 142, 120),
                Color.fromARGB(255, 54, 45, 35),
              ],
            ),
          ),
        ),

        // Mosque PNG at top center
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 400,
              width: 1000,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/mosque.png'),
                  fit: BoxFit.fitWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A3728).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Welcome Text
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'Assalam o Alaikum,',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 219, 196, 177),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Welcome to DeenConnect',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 226, 201, 180),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Streak Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF57C00),
                          Color(0xFFFF9800),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          '$_dailyStreak روز مسلسل',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A3728).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF4A3728).withOpacity(0.3)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationWeatherCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 219, 193, 163),
            Color.fromARGB(255, 182, 157, 132),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xFF4A3728), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Live Location',
                    style: TextStyle(
                      color: Color(0xFF4A3728),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$_city ${_country.isNotEmpty ? ", $_country" : ""}',
                style: TextStyle(
                  color: Color(0xFF4A3728),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _todayDate,
                style: const TextStyle(
                  color: Color(0xFF4A3728),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _hijriDate,
                style: const TextStyle(
                  color: Color(0xFF4A3728),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.wb_sunny, color: Color(0xFF4A3728), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Sunny • 25°C',
                    style: TextStyle(
                      color: Color(0xFF4A3728),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Weather Icon with Side Icons
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A3728).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF4A3728).withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  color: Color.fromARGB(255, 194, 191, 22),
                  size: 40,
                ),
              ),
              const SizedBox(height: 10),

              // Side Icons Row
              Row(
                children: [
                  _buildSideIcon(Icons.refresh, 'Update'),
                  const SizedBox(width: 10),
                  _buildSideIcon(Icons.map, 'Map'),
                  const SizedBox(width: 10),
                  _buildSideIcon(Icons.calendar_today, 'Date'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasbeehQuickPreview(Map<String, dynamic> tasbeeh) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TasbeehDashboard(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 168, 138, 104),
              Color.fromARGB(255, 58, 46, 33),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 122, 94, 61).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.psychology_alt,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tasbeeh Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Uthmanic',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timer, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Now Begin',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Main Content
            Row(
              children: [
                // Progress Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: tasbeeh['progress'] as double,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${tasbeeh['current']}/${tasbeeh['target']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(tasbeeh['progress'] * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // Tasbeeh Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tasbeeh['arabic'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Uthmanic',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tasbeeh['name'] as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department,
                                    size: 12,
                                    color: Color.fromARGB(255, 206, 131, 18)),
                                const SizedBox(width: 4),
                                Text(
                                  '${tasbeeh['streak']} دن',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'روزانہ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow,
                            color: Color.fromARGB(255, 48, 39, 22)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DigitalCounterScreen(
                                tasbeeh: tasbeeh,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lets start',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTasbeehStat(
                    'Total Tasbeeh', '$_totalTasbeehCount', Icons.numbers),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildTasbeehStat('Streak', '$_dailyStreak Days',
                    Icons.local_fire_department),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildTasbeehStat('Complete', '3/5', Icons.check_circle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbeehStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.8)),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSideIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A3728).withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF4A3728).withOpacity(0.1)),
          ),
          child: Icon(icon, color: const Color(0xFF4A3728), size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF4A3728).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimesCard(
      Map<String, dynamic> nextPrayer, Map<String, dynamic> lastPrayer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 219, 193, 163),
            Color.fromARGB(255, 182, 157, 132),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Prayer Times',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A3728).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF4A3728).withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Color(0xFF4A3728)),
                    SizedBox(width: 6),
                    Text(
                      'Nankana Sahib',
                      style: TextStyle(
                        color: Color(0xFF4A3728),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Next Prayer Highlight
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A3728),
                  Color(0xFF806254),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3728).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Prayer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(nextPrayer['icon'] as IconData,
                              color: Colors.white, size: 30),
                          const SizedBox(width: 12),
                          Text(
                            nextPrayer['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Starts in: ${nextPrayer['timeLeft']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last prayer (${lastPrayer['name']}) ended ${lastPrayer['endedAgo']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nextPrayer['time'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            '${nextPrayer['timeLeft']} left',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // All Prayers Grid with Icons
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: prayers.length,
            itemBuilder: (context, index) {
              final prayer = prayers[index];
              final isPassed = prayer['passed'] as bool;
              final isNext = prayer['next'] as bool? ?? false;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isNext
                      ? const Color(0xFF4A3728)
                      : isPassed
                          ? (prayer['color'] as Color).withOpacity(0.1)
                          : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isNext
                        ? Colors.transparent
                        : (prayer['color'] as Color).withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isNext
                          ? const Color(0xFF4A3728).withOpacity(0.4)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      prayer['icon'] as IconData,
                      color: isNext ? Colors.white : prayer['color'] as Color,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prayer['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isNext ? Colors.white : prayer['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prayer['time'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isNext ? Colors.white : prayer['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPassed
                          ? prayer['endedAgo'] as String
                          : prayer['timeLeft'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isNext ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // View Schedule Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrayerTimesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3728),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                shadowColor: const Color(0xFF4A3728).withOpacity(0.3),
              ),
              icon: const Icon(Icons.schedule, size: 18),
              label: const Text(
                'View Complete Schedule',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 219, 193, 163),
            Color.fromARGB(255, 182, 157, 132),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3728),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemCount: quickAccessItems.length,
            itemBuilder: (context, index) {
              final item = quickAccessItems[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {});
                  },
                  onTapUp: (_) {
                    setState(() {});
                  },
                  onTapCancel: () {
                    setState(() {});
                  },
                  onTap: () {
                    final screen = item['screen'] as String;
                    switch (screen) {
                      case 'qibla':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QiblaScreen(),
                          ),
                        );
                        break;
                      case 'quran':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuranScreen(),
                          ),
                        );
                        break;
                      case 'duas':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DuasScreen(),
                          ),
                        );
                        break;
                      case 'tasbeeh':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TasbeehDashboard(),
                          ),
                        );
                        break;
                      case 'tracker':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrackerScreen(),
                          ),
                        );
                        break;
                      case 'calendar':
                        // TODO: Add calendar screen
                        break;
                      case 'Hadith':
                        // TODO: Add masjid finder screen
                        break;
                      case 'names':
                        // TODO: Add azan settings screen
                        break;
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF4A3728).withOpacity(0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A3728).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A3728).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF4A3728).withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              item['icon'] as IconData,
                              color: const Color(0xFF4A3728),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A3728),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Side Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAccessSideIcon(Icons.add_circle, 'New Tasbeeh',
                  onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTasbeehScreen(),
                  ),
                );
              }),
              _buildQuickAccessSideIcon(Icons.history, 'Recent'),
              _buildQuickAccessSideIcon(Icons.download, 'Offline'),
              _buildQuickAccessSideIcon(Icons.bookmark_border, 'Saved'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSideIcon(IconData icon, String label,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4A3728).withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: const Color(0xFF4A3728).withOpacity(0.1)),
            ),
            child: Icon(icon, color: const Color(0xFF4A3728), size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF4A3728).withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReminderCard() {
    final reminder = dailyReminders[_currentReminderIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A3728),
            Color(0xFF806254),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (value * 0.1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            reminder['type'] == 'Quran'
                                ? Icons.book
                                : Icons.lightbulb,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            reminder['type'] == 'Quran'
                                ? 'Quranic Verse'
                                : 'Hadith of the Day',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentReminderIndex =
                        (_currentReminderIndex + 1) % dailyReminders.length;
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Ornamental Design
          Center(
            child: Stack(
              children: [
                // Decorative Circles
                Positioned(
                  left: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                  ),
                ),

                // Quote in Center
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Decorative Line
                      Container(
                        height: 2,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Animated Text
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 20),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          '"${reminder['text']}"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 2,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Source and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset((1 - value) * 20, 0),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  reminder['source'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_border,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.copy, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasbeehProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 126, 104, 75),
            Color.fromARGB(255, 61, 48, 30),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 56, 43, 17).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tasbeeh Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TasbeehDashboard(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Circle
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _dailyProgress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(_dailyProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'analysis',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressStat(
                  'Entire Praise', '$_totalTasbeehCount', Icons.psychology_alt),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildProgressStat(
                  'Streak', '$_dailyStreak Day', Icons.local_fire_department),
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildProgressStat('Finshed Tasbeeh', '${tasbeehList.length}',
                  Icons.check_circle),
            ],
          ),

          const SizedBox(height: 20),

          // Badges Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Awards Received',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: badge['earned'] as bool
                                  ? badge['color'] as Color
                                  : badge['color'] as Color,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                badge['icon'] as IconData,
                                color: badge['earned'] as bool
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge['name'] as String,
                            style: TextStyle(
                              color: badge['earned'] as bool
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTasbeehScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add New Tasbeeh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 58, 44, 27),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DigitalCounterScreen(
                        tasbeeh: tasbeehList[_currentTasbeehIndex],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('Get started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 184, 153, 107),
                  foregroundColor: const Color.fromARGB(255, 53, 38, 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 219, 193, 163),
            Color.fromARGB(255, 182, 157, 132),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Progress',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3728),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              // Progress Circle
              Expanded(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 10,
                            backgroundColor:
                                const Color(0xFF4A3728).withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A3728)),
                          ),
                        ),
                        const Column(
                          children: [
                            Text(
                              '85%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A3728),
                              ),
                            ),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A3728),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A3728).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF4A3728).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 14, color: Color(0xFF4A3728)),
                          SizedBox(width: 6),
                          Text(
                            '',
                            style: TextStyle(
                              color: Color(0xFF4A3728),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Stats
              Expanded(
                child: Column(
                  children: [
                    _buildStatItem('Prayers', '3/5', Icons.check_circle,
                        const Color.fromARGB(255, 105, 81, 44)),
                    const SizedBox(height: 12),
                    _buildStatItem('Duas', '12/20', Icons.favorite,
                        const Color.fromARGB(255, 105, 81, 44)),
                    const SizedBox(height: 12),
                    _buildStatItem('Quran', '15min', Icons.book,
                        const Color.fromARGB(255, 105, 81, 44)),
                    const SizedBox(height: 12),
                    _buildStatItem('Sunnah', '4/12', Icons.star,
                        const Color.fromARGB(255, 105, 81, 44)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // View Progress Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrackerScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A3728),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insights, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'View Detailed Analytics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF4A3728).withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3728),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Digital Counter Screen (Simplified version)
// --- IS CODE KO LINE 512 SE END TAK REPLACE KAREIN ---

// Sab se upar ye import zaroor lagayen (agar file alag folder mein hai to path check karein)

class DigitalCounterScreen extends StatefulWidget {
  final Map<String, dynamic> tasbeeh;
  const DigitalCounterScreen({super.key, required this.tasbeeh});

  @override
  State<DigitalCounterScreen> createState() => _DigitalCounterScreenState();
}

class _DigitalCounterScreenState extends State<DigitalCounterScreen> {
  int _currentCount = 0;

  @override
  void initState() {
    super.initState();
    // App khultay hi Service se data mangwaya ja raha hai
    _loadFromService();
  }

  // Backend se data lany ka function
  Future<void> _loadFromService() async {
    // TasbeehService se purana count maang rahe hain
    int savedCount = await TasbeehService.getCount(widget.tasbeeh['name'], 0);

    if (mounted) {
      // Check ke screen abhi bhi open hai ya nahi
      setState(() {
        _currentCount = savedCount;
      });
    }
  }

  // NOTE: Yahan se purane functions (_saveCount, _loadSavedCount) DELETE kar diye hain.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tasbeeh['name'] as String),
        backgroundColor: const Color(0xFF006D5B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tasbeeh['arabic'] as String,
              style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 40, 27)),
            ),
            const SizedBox(height: 40),
            Text(
              '$_currentCount',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            // --- TAP BUTTON (Increment) ---
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentCount++;
                });
                // Yahan ab direct Service call ho rahi hai
                TasbeehService.saveCount(widget.tasbeeh['name'], _currentCount);
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 54, 41, 19),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child:
                    const Icon(Icons.touch_app, size: 70, color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            // --- RESET BUTTON ---
            IconButton(
              icon: const Icon(Icons.refresh, size: 30, color: Colors.red),
              onPressed: () {
                setState(() {
                  _currentCount = 0;
                });
                // Reset karte waqt 0 bhej rahe hain
                TasbeehService.saveCount(widget.tasbeeh['name'], 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
