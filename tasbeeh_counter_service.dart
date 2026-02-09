import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/tasbeeh_counter_model.dart';

class TasbeehCounterService {
  // Singleton instance
  static final TasbeehCounterService _instance =
      TasbeehCounterService._internal();

  factory TasbeehCounterService() {
    return _instance;
  }

  TasbeehCounterService._internal();

  Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // Initialize database
    String path = join(await getDatabasesPath(), 'tasbeeh_counter.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tasbeeh_counters table
        await db.execute('''
          CREATE TABLE tasbeeh_counters(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            targetCount INTEGER NOT NULL,
            currentCount INTEGER NOT NULL,
            targetDate TEXT NOT NULL,
            creationDate TEXT NOT NULL,
            completionDates TEXT,
            isCompletedToday INTEGER,
            dailyProgress TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  // Add new tasbeeh counter
  Future<void> addTasbeehCounter(TasbeehCounter counter) async {
    final db = await database;

    await db.insert(
      'tasbeeh_counters',
      {
        'id': counter.id,
        'name': counter.name,
        'description': counter.description,
        'targetCount': counter.targetCount,
        'currentCount': counter.currentCount,
        'targetDate': counter.targetDate.toIso8601String(),
        'creationDate': counter.creationDate.toIso8601String(),
        'completionDates': counter.completionDates
            .map((date) => date.toIso8601String())
            .join(','),
        'isCompletedToday': counter.isCompletedToday ? 1 : 0,
        'dailyProgress': counter.dailyProgress.entries
            .map((e) => '${e.key}:${e.value}')
            .join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all tasbeeh counters
  Future<List<TasbeehCounter>> getAllCounters() async {
    try {
      final db = await database;

      // Query all records
      final List<Map<String, dynamic>> maps =
          await db.query('tasbeeh_counters');

      // Convert to TasbeehCounter objects
      List<TasbeehCounter> counters = [];

      for (var map in maps) {
        try {
          // Parse completion dates
          List<DateTime> completionDates = [];
          String completionDatesStr = map['completionDates']?.toString() ?? '';
          if (completionDatesStr.isNotEmpty) {
            List<String> dateStrings = completionDatesStr.split(',');
            for (String dateStr in dateStrings) {
              if (dateStr.isNotEmpty) {
                try {
                  completionDates.add(DateTime.parse(dateStr));
                } catch (e) {
                  print('Error parsing date: $dateStr');
                }
              }
            }
          }

          // Parse daily progress
          Map<String, int> dailyProgress = {};
          String dailyProgressStr = map['dailyProgress']?.toString() ?? '';
          if (dailyProgressStr.isNotEmpty) {
            List<String> entries = dailyProgressStr.split(',');
            for (String entry in entries) {
              List<String> parts = entry.split(':');
              if (parts.length == 2) {
                String key = parts[0];
                int? value = int.tryParse(parts[1]);
                if (value != null) {
                  dailyProgress[key] = value;
                }
              }
            }
          }

          // Create TasbeehCounter object
          TasbeehCounter counter = TasbeehCounter(
            id: map['id'].toString(),
            name: map['name'].toString(),
            description: map['description']?.toString() ?? '',
            targetCount: int.tryParse(map['targetCount'].toString()) ?? 0,
            currentCount: int.tryParse(map['currentCount'].toString()) ?? 0,
            targetDate: DateTime.parse(map['targetDate'].toString()),
            creationDate: DateTime.parse(map['creationDate'].toString()),
            completionDates: completionDates,
            isCompletedToday: (map['isCompletedToday'] ?? 0) == 1,
            dailyProgress: dailyProgress,
          );

          counters.add(counter);
        } catch (e) {
          print('Error parsing counter data: $e');
        }
      }

      return counters;
    } catch (e) {
      print('Error getting all counters: $e');
      return [];
    }
  }

  // Update tasbeeh counter
  Future<void> updateCounter(TasbeehCounter counter) async {
    try {
      final db = await database;

      await db.update(
        'tasbeeh_counters',
        {
          'name': counter.name,
          'description': counter.description,
          'targetCount': counter.targetCount,
          'currentCount': counter.currentCount,
          'targetDate': counter.targetDate.toIso8601String(),
          'completionDates': counter.completionDates
              .map((date) => date.toIso8601String())
              .join(','),
          'isCompletedToday': counter.isCompletedToday ? 1 : 0,
          'dailyProgress': counter.dailyProgress.entries
              .map((e) => '${e.key}:${e.value}')
              .join(','),
        },
        where: 'id = ?',
        whereArgs: [counter.id],
      );
    } catch (e) {
      print('Error updating counter: $e');
    }
  }

  // Delete tasbeeh counter
  Future<void> deleteCounter(String id) async {
    try {
      final db = await database;
      await db.delete(
        'tasbeeh_counters',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting counter: $e');
    }
  }

  // Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
