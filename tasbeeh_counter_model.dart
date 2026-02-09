class TasbeehCounter {
  final String id;
  final String name;
  final String description;
  final int targetCount;
  int currentCount;
  final DateTime targetDate;
  final DateTime creationDate;
  final List<DateTime> completionDates;
  final bool isCompletedToday;
  final Map<String, int> dailyProgress;

  TasbeehCounter({
    required this.id,
    required this.name,
    required this.description,
    required this.targetCount,
    required this.currentCount,
    required this.targetDate,
    required this.creationDate,
    List<DateTime>? completionDates,
    this.isCompletedToday = false,
    Map<String, int>? dailyProgress,
  })  : completionDates = completionDates ?? [],
        dailyProgress = dailyProgress ?? {};

  // Increment counter
  void increment() {
    currentCount++;

    // Update today's progress
    String today = DateTime.now().toIso8601String().split('T')[0];
    dailyProgress[today] = (dailyProgress[today] ?? 0) + 1;

    // Check if target reached
    if (currentCount >= targetCount) {
      completionDates.add(DateTime.now());
    }
  }

  // Reset counter
  void reset() {
    currentCount = 0;
  }

  // Get progress percentage
  double get progress {
    if (targetCount <= 0) return 0.0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }

  // Get remaining count
  int get remaining {
    return targetCount - currentCount;
  }

  // Check if completed
  bool get isCompleted {
    return currentCount >= targetCount;
  }

  // Get today's count
  int get todayCount {
    String today = DateTime.now().toIso8601String().split('T')[0];
    return dailyProgress[today] ?? 0;
  }

  // Get monthly statistics - YE NAYA METHOD ADD KIYA
  Map<String, int> get monthlyStats {
    Map<String, int> stats = {};

    // Agar dailyProgress empty hai to empty map return karen
    if (dailyProgress.isEmpty) return stats;

    // Har entry se month extract karen
    for (var entry in dailyProgress.entries) {
      String dateKey = entry.key;

      // Check if date is in correct format (yyyy-mm-dd)
      if (dateKey.length >= 7) {
        // First 7 characters: yyyy-mm
        String monthKey = dateKey.substring(0, 7);
        stats[monthKey] = (stats[monthKey] ?? 0) + entry.value;
      }
    }

    return stats;
  }

  // Copy with new values
  TasbeehCounter copyWith({
    String? id,
    String? name,
    String? description,
    int? targetCount,
    int? currentCount,
    DateTime? targetDate,
    DateTime? creationDate,
    List<DateTime>? completionDates,
    bool? isCompletedToday,
    Map<String, int>? dailyProgress,
  }) {
    return TasbeehCounter(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      targetDate: targetDate ?? this.targetDate,
      creationDate: creationDate ?? this.creationDate,
      completionDates: completionDates ?? this.completionDates,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      dailyProgress: dailyProgress ?? this.dailyProgress,
    );
  }

  // Helper method to get month name
  String getMonthName(String monthKey) {
    // monthKey format: yyyy-mm
    try {
      List<String> parts = monthKey.split('-');
      if (parts.length >= 2) {
        int month = int.parse(parts[1]);
        List<String> monthNames = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        if (month >= 1 && month <= 12) {
          return '${monthNames[month - 1]} ${parts[0]}';
        }
      }
    } catch (e) {
      print('Error parsing month: $e');
    }
    return monthKey;
  }

  // Get last 6 months statistics
  Map<String, int> getLast6MonthsStats() {
    Map<String, int> last6Months = {};
    Map<String, int> allStats = monthlyStats;

    // Get current month
    DateTime now = DateTime.now();
    String currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // Generate last 6 months keys
    for (int i = 0; i < 6; i++) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      String monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      last6Months[monthKey] = allStats[monthKey] ?? 0;
    }

    return last6Months;
  }
}
