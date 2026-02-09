class Ayah {
  final int number;
  final String text;
  final String translation;
  final int surahNumber;
  final int numberInSurah;
  final int? juz;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.translation,
    required this.surahNumber,
    required this.numberInSurah,
    this.juz,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda = false,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      translation: json['translation'] ?? '',
      surahNumber: json['surahNumber'] ?? json['surah']?['number'] ?? 0,
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'] == true,
    );
  }
}
