import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/surah_model.dart';
import '../data/models/ayah_model.dart';

class QuranService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surah'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahsData = data['data'];

        return surahsData.map((json) => Surah.fromJson(json)).toList();
      } else {
        // Fallback
        return [
          Surah(
            number: 1,
            name: 'الفاتحة',
            englishName: 'Al-Fatihah',
            englishNameTranslation: 'The Opening',
            revelationType: 'Meccan',
            numberOfAyahs: 7,
          ),
          Surah(
            number: 2,
            name: 'البقرة',
            englishName: 'Al-Baqarah',
            englishNameTranslation: 'The Cow',
            revelationType: 'Medinan',
            numberOfAyahs: 286,
          ),
        ];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surah/$surahNumber'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> ayahsData = data['data']['ayahs'];

        return ayahsData.map((json) {
          return Ayah(
            number: json['number'],
            text: json['text'] ?? '',
            translation: '',
            surahNumber: surahNumber,
            numberInSurah: json['numberInSurah'],
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
