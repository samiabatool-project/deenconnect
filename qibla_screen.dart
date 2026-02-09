import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deen_connect/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  double? _compassHeading = 0;
  double? _qiblaDirection = 45.0;
  double? _deviceDirection = 0;
  bool _isLoading = true;
  bool _isCalibrating = false;
  bool _qiblaFound = false;
  String _distanceText = 'Calculating...';
  Position? _currentPosition;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initializeLocationAndCompass();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeLocationAndCompass() async {
    await _getCurrentLocation();
    _startCompass();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceError();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _showPermissionError();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _calculateQiblaDirection(position);
        _calculateDistance(position);
        _isLoading = false;
      });
    } catch (e) {
      print('Location error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateQiblaDirection(Position position) {
    const double kaabaLat = 21.4225;
    const double kaabaLng = 39.8262;

    double lat1 = position.latitude * pi / 180.0;
    double lon1 = position.longitude * pi / 180.0;
    double lat2 = kaabaLat * pi / 180.0;
    double lon2 = kaabaLng * pi / 180.0;

    double qibla = atan2(
      sin(lon2 - lon1),
      cos(lat1) * tan(lat2) - sin(lat1) * cos(lon2 - lon1),
    );

    double qiblaDegrees = (qibla * 180 / pi + 360) % 360;

    setState(() {
      _qiblaDirection = qiblaDegrees;
    });

    print("Qibla Direction Calculated: $qiblaDegrees°");
  }

  void _checkQiblaFound() {
    if (_compassHeading != null && _qiblaDirection != null) {
      double difference = ((_qiblaDirection! - _compassHeading!) + 360) % 360;
      difference = difference > 180 ? 360 - difference : difference;

      if (difference.abs() < 5) {
        // Within 5 degrees
        if (!_qiblaFound) {
          setState(() {
            _qiblaFound = true;
          });
          _triggerHapticFeedback();
        }
      } else {
        setState(() {
          _qiblaFound = false;
        });
      }
    }
  }

  void _triggerHapticFeedback() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }
  }

  void _calculateDistance(Position position) {
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      21.4225,
      39.8262,
    );

    double distanceInKm = distanceInMeters / 1000;
    setState(() {
      if (distanceInKm < 1000) {
        _distanceText = '${distanceInKm.toStringAsFixed(1)} km';
      } else {
        _distanceText = '${(distanceInKm / 1000).toStringAsFixed(1)}k km';
      }
    });
  }

  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        setState(() {
          _compassHeading = event.heading;
          _deviceDirection = event.heading;
          _checkQiblaFound();
        });
        print("Compass Heading: ${event.heading}°");
      }
    });
  }

  void _calibrateCompass() {
    setState(() {
      _isCalibrating = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isCalibrating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Compass calibrated successfully'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  void _showLocationServiceError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enable location services'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showPermissionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location permission required'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  String _getDirectionName(double angle) {
    if (angle >= 337.5 || angle < 22.5) return 'North';
    if (angle >= 22.5 && angle < 67.5) return 'North-East';
    if (angle >= 67.5 && angle < 112.5) return 'East';
    if (angle >= 112.5 && angle < 157.5) return 'South-East';
    if (angle >= 157.5 && angle < 202.5) return 'South';
    if (angle >= 202.5 && angle < 247.5) return 'South-West';
    if (angle >= 247.5 && angle < 292.5) return 'West';
    return 'North-West';
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0F1C) : const Color(0xFFF8FAFF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(255, 51, 42, 25).withOpacity(0.9),
                      const Color.fromARGB(255, 134, 112, 79).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: SvgPicture.asset(
                          'assets/svg/islamic_pattern.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
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
                            'Qibla Finder',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Find the direction to Holy Kaaba',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  if (_isLoading)
                    _buildLoadingShimmer()
                  else
                    _buildModernCompass(size, isDark),

                  const SizedBox(height: 40),

                  // Stats Grid
                  _buildStatsGrid(isDark),

                  const SizedBox(height: 32),

                  // Control Panel
                  _buildControlPanel(isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.compass_calibration,
                  size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Finding Qibla...',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCompass(Size size, bool isDark) {
    double compassSize = min(size.width * 0.85, 320);
    double heading = _compassHeading ?? 0;
    double qiblaAngle = _qiblaDirection ?? 45;

    // Calculate relative angle for Qibla needle
    double relativeQiblaAngle = (qiblaAngle - heading + 360) % 360;

    return Container(
      width: compassSize,
      height: compassSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            isDark ? const Color.fromARGB(255, 50, 39, 26) : Colors.white,
            isDark
                ? const Color.fromARGB(255, 36, 27, 15)
                : const Color(0xFFF0F4FF),
          ],
          stops: const [0.2, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color.fromARGB(255, 145, 112, 70).withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Outer Border
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 82, 69, 45).withOpacity(0.3),
                width: 2,
              ),
            ),
          ),

          // Degree Markings
          ..._buildDegreeMarkings(compassSize, isDark),

          // Cardinal Directions
          ..._buildCardinalDirections(compassSize, isDark),

          // QIBLA NEEDLE (FIXED - Rotates with compass)
          Transform.rotate(
            angle: -relativeQiblaAngle * pi / 180,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Qibla Needle
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _qiblaFound ? _pulseAnimation.value : 1.0,
                        child: Container(
                          width: 6,
                          height: compassSize * 0.35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _qiblaFound
                                  ? [
                                      const Color(0xFFFFD700),
                                      const Color(0xFFFFA500)
                                    ]
                                  : [
                                      const Color(0xFFD32F2F),
                                      const Color(0xFFF44336)
                                    ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: (_qiblaFound ? Colors.amber : Colors.red)
                                    .withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Qibla Label
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _qiblaFound
                            ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                            : [
                                const Color(0xFFD32F2F),
                                const Color(0xFFF44336)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (_qiblaFound ? Colors.amber : Colors.red)
                              .withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.mosque,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'قبلة',
                          style: GoogleFonts.amiriQuran(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // COMPASS NEEDLE (NORTH) - Rotates with device
          if (_compassHeading != null)
            Transform.rotate(
              angle: -heading * pi / 180,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // North Needle
                    Container(
                      width: 8,
                      height: compassSize * 0.35,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2196F3).withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),

                    // North Label
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 190, 159, 111)
                                .withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        'NORTH',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Center Point
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 66, 50, 31),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 83, 68, 44)
                            .withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Heading Display
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    _getDirectionName(_qiblaDirection ?? 0),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_qiblaDirection?.toStringAsFixed(1)}°',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current Heading
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Device Heading',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_compassHeading?.toStringAsFixed(1) ?? '0.0'}°',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 165, 137, 94),
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

  List<Widget> _buildDegreeMarkings(double size, bool isDark) {
    List<Widget> markings = [];

    for (int i = 0; i < 360; i += 30) {
      bool isMajor = i % 90 == 0;

      markings.add(
        Transform.rotate(
          angle: i * pi / 180,
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: isMajor ? 4 : 2,
              height: isMajor ? 20 : 12,
              decoration: BoxDecoration(
                color: isMajor
                    ? const Color.fromARGB(255, 68, 54, 28)
                    : Colors.grey[400]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      );
    }

    return markings;
  }

  List<Widget> _buildCardinalDirections(double size, bool isDark) {
    const directions = [
      {'label': 'N', 'angle': 0, 'color': Color(0xFF2196F3)},
      {'label': 'E', 'angle': 90, 'color': Color(0xFF4CAF50)},
      {'label': 'S', 'angle': 180, 'color': Color(0xFFF44336)},
      {'label': 'W', 'angle': 270, 'color': Color(0xFFFF9800)},
      {'label': 'NE', 'angle': 45, 'color': Colors.grey},
      {'label': 'SE', 'angle': 135, 'color': Colors.grey},
      {'label': 'SW', 'angle': 225, 'color': Colors.grey},
      {'label': 'NW', 'angle': 315, 'color': Colors.grey},
    ];

    return directions.map((dir) {
      final angle = dir['angle'] as double;
      final color = dir['color'] as Color;
      final isMain = ['N', 'E', 'S', 'W'].contains(dir['label']);

      return Transform.rotate(
        angle: angle * pi / 180,
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(
              horizontal: isMain ? 12 : 8,
              vertical: isMain ? 8 : 4,
            ),
            decoration: BoxDecoration(
              color: isMain ? color.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(isMain ? 12 : 8),
              border: isMain
                  ? Border.all(color: color.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Text(
              dir['label'] as String,
              style: GoogleFonts.poppins(
                fontSize: isMain ? 16 : 12,
                fontWeight: isMain ? FontWeight.w700 : FontWeight.w600,
                color: isMain ? color : Colors.grey[600],
                letterSpacing: isMain ? 1.5 : 1.0,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildStatsGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildStatItem(
          icon: Icons.explore,
          title: 'Qibla Direction',
          value: '${_qiblaDirection?.toStringAsFixed(1) ?? '0.0'}°',
          subtitle: _getDirectionName(_qiblaDirection ?? 0),
          color: const Color(0xFFD32F2F),
          isDark: isDark,
        ),
        _buildStatItem(
          icon: Icons.my_location,
          title: 'Distance to Kaaba',
          value: _distanceText,
          subtitle: 'From your location',
          color: const Color(0xFF4CAF50),
          isDark: isDark,
        ),
        _buildStatItem(
          icon: Icons.compass_calibration,
          title: 'Accuracy',
          value: '±2°',
          subtitle: 'High Precision',
          color: const Color(0xFF2196F3),
          isDark: isDark,
        ),
        _buildStatItem(
          icon: Icons.location_on,
          title: 'Your Location',
          value: _currentPosition != null
              ? '${_currentPosition!.latitude.toStringAsFixed(2)}°'
              : 'Unknown',
          subtitle: _currentPosition != null
              ? '${_currentPosition!.longitude.toStringAsFixed(2)}°'
              : 'Enable location',
          color: const Color(0xFFFF9800),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Compass Controls',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _qiblaFound
                      ? const Color(0xFF4CAF50).withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _qiblaFound
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _qiblaFound ? const Color(0xFF4CAF50) : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _qiblaFound ? 'Qibla Found!' : 'Finding Qibla...',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color:
                            _qiblaFound ? const Color(0xFF4CAF50) : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _calibrateCompass,
                  icon: _isCalibrating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.refresh, size: 20),
                  label: Text(
                    _isCalibrating ? 'CALIBRATING' : 'CALIBRATE',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 88, 67, 39),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _getCurrentLocation(),
                icon: const Icon(Icons.gps_fixed, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                  foregroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Share functionality
                },
                icon: const Icon(Icons.share, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 141, 124, 79).withOpacity(0.1),
                  foregroundColor: const Color.fromARGB(255, 114, 87, 56),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
