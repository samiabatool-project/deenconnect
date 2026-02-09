import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/surah_model.dart';
import '../data/models/ayah_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  // -----------------------
  // DATABASE INITIALIZATION
  // -----------------------
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'deen_connect.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Surahs table
    await db.execute('''
      CREATE TABLE surahs(
        id INTEGER PRIMARY KEY,
        number INTEGER,
        name TEXT,
        englishName TEXT,
        englishNameTranslation TEXT,
        revelationType TEXT,
        numberOfAyahs INTEGER
      )
    ''');

    // Ayahs table
    await db.execute('''
      CREATE TABLE ayahs(
        id INTEGER PRIMARY KEY,
        number INTEGER,
        text TEXT,
        translation TEXT,
        surahNumber INTEGER,
        numberInSurah INTEGER
      )
    ''');

    // Bookmarks table
    await db.execute('''
      CREATE TABLE bookmarks(
        id INTEGER PRIMARY KEY,
        surahNumber INTEGER,
        ayahNumber INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // -----------------------
  // SURAH OPERATIONS
  // -----------------------
  Future<void> saveSurahs(List<Surah> surahs) async {
    final db = await database;
    Batch batch = db.batch();

    for (Surah surah in surahs) {
      batch.insert('surahs', {
        'number': surah.number,
        'name': surah.name,
        'englishName': surah.englishName,
        'englishNameTranslation': surah.englishNameTranslation,
        'revelationType': surah.revelationType,
        'numberOfAyahs': surah.numberOfAyahs,
      });
    }

    await batch.commit();
  }

  Future<List<Surah>> getSurahs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('surahs');

    return List.generate(maps.length, (i) {
      return Surah(
        number: maps[i]['number'],
        name: maps[i]['name'],
        englishName: maps[i]['englishName'],
        englishNameTranslation: maps[i]['englishNameTranslation'],
        revelationType: maps[i]['revelationType'],
        numberOfAyahs: maps[i]['numberOfAyahs'],
      );
    });
  }

  // -----------------------
  // AYAH OPERATIONS
  // -----------------------
  Future<void> saveAyahs(List<Ayah> ayahs) async {
    final db = await database;
    Batch batch = db.batch();

    for (Ayah ayah in ayahs) {
      batch.insert('ayahs', {
        'number': ayah.number,
        'text': ayah.text,
        'translation': ayah.translation,
        'surahNumber': ayah.surahNumber,
        'numberInSurah': ayah.numberInSurah,
      });
    }

    await batch.commit();
  }

  Future<List<Ayah>> getAyahs(int surahNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ayahs',
      where: 'surahNumber = ?',
      whereArgs: [surahNumber],
      orderBy: 'numberInSurah',
    );

    return List.generate(maps.length, (i) {
      return Ayah(
        number: maps[i]['number'],
        text: maps[i]['text'],
        translation: maps[i]['translation'],
        surahNumber: maps[i]['surahNumber'],
        numberInSurah: maps[i]['numberInSurah'],
      );
    });
  }

  // -----------------------
  // PREFERENCES / SETTINGS
  // -----------------------
  Future<Map<String, dynamic>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'notifications': prefs.getBool('notifications') ?? true,
      'darkMode': prefs.getBool('darkMode') ?? false,
      'calculationMethod': prefs.getString('calculationMethod') ?? 'Karachi',
      'language': prefs.getString('language') ?? 'English',
      'hapticFeedback': prefs.getBool('hapticFeedback') ?? true,
      'tasbihReminders': prefs.getBool('tasbihReminders') ?? true,
    };
  }

  Future<void> setPreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  // Save multiple preferences at once
  Future<void> savePreferences(Map<String, dynamic> prefsMap) async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in prefsMap.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    }
  }
}
