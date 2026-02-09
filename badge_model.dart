import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final String arabicName;
  final IconData icon;
  final Color color;
  final BadgeType type;
  final int pointsRequired;
  final DateTime earnedAt;
  final bool isEarned;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.arabicName,
    required this.icon,
    required this.color,
    required this.type,
    required this.pointsRequired,
    required this.earnedAt,
    this.isEarned = false,
  });
}

enum BadgeType {
  DAILY_STREAK,
  MONTHLY_TARGET,
  TOTAL_COUNT,
  CONSISTENCY,
  SPECIAL_EVENT,
}
