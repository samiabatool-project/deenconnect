import 'package:flutter/material.dart';
import 'package:deen_connect/core/theme/app_colors.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class DuaCategory {
  final String id;
  final String title;
  final String arabicTitle;
  final IconData icon;
  final Color color;
  final int count;

  DuaCategory({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.icon,
    required this.color,
    required this.count,
  });
}

class Dua {
  final String id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String urduTranslation;
  final String reference;
  final String category;
  final bool isFavorite;
  final int times;

  Dua({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.urduTranslation,
    required this.reference,
    required this.category,
    required this.isFavorite,
    this.times = 1,
  });
}

class _DuasScreenState extends State<DuasScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _showFavoritesOnly = false;

  final List<DuaCategory> _categories = [
    DuaCategory(
      id: 'all',
      title: 'All Duas',
      arabicTitle: 'كل الأدعية',
      icon: Icons.all_inclusive,
      color: const Color(0xFF7D4E29),
      count: 45,
    ),
    DuaCategory(
      id: 'morning',
      title: 'Morning',
      arabicTitle: 'أذكار الصباح',
      icon: Icons.wb_sunny,
      color: Colors.orange.shade700,
      count: 12,
    ),
    DuaCategory(
      id: 'evening',
      title: 'Evening',
      arabicTitle: 'أذكار المساء',
      icon: Icons.nights_stay,
      color: Colors.indigo.shade700,
      count: 12,
    ),
    DuaCategory(
      id: 'sleep',
      title: 'Sleep',
      arabicTitle: 'أذكار النوم',
      icon: Icons.bedtime,
      color: Colors.purple.shade700,
      count: 8,
    ),
    DuaCategory(
      id: 'prayer',
      title: 'Prayer',
      arabicTitle: 'أدعية الصلاة',
      icon: Icons.mosque,
      color: Colors.green.shade700,
      count: 15,
    ),
    DuaCategory(
      id: 'food',
      title: 'Food',
      arabicTitle: 'أدعية الطعام',
      icon: Icons.restaurant,
      color: Colors.red.shade700,
      count: 6,
    ),
    DuaCategory(
      id: 'travel',
      title: 'Travel',
      arabicTitle: 'أدعية السفر',
      icon: Icons.directions_car,
      color: Colors.blue.shade700,
      count: 8,
    ),
    DuaCategory(
      id: 'quranic',
      title: 'Quranic',
      arabicTitle: 'أدعية قرآنية',
      icon: Icons.menu_book,
      color: Color(0xFF2E7D32),
      count: 10,
    ),
  ];

  final List<Dua> _allDuas = [
    // Morning Duas (12)
    Dua(
      id: '1',
      title: 'Morning Remembrance 1',
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
      transliteration:
          'Asbahna wa asbahal-mulku lillah, walhamdulillah, la ilaha illallah wahdahu la sharika lah',
      translation:
          'We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
      urduTranslation:
          'ہم صبح کو پہنچ گئے اور اس وقت تمام بادشاہی اللہ کی ہے، اور تمام تعریف اللہ کے لیے ہے۔ اللہ کے سوا کوئی معبود برحق نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔',
      reference: 'Muslim 2723',
      category: 'morning',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '2',
      title: 'Seeking Protection',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min sharri ma khalaq',
      translation:
          'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      urduTranslation:
          'میں اللہ کے کامل کلمات کی پناہ لیتا ہوں اس کی مخلوقات کے شر سے۔',
      reference: 'Tirmidhi 3604',
      category: 'morning',
      isFavorite: true,
      times: 3,
    ),
    Dua(
      id: '3',
      title: 'Dua for Morning',
      arabic:
          'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      transliteration:
          'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur',
      translation:
          'O Allah, by Your will we have reached the morning and by Your will we have reached the evening, by Your will we live and die and unto You is our resurrection.',
      urduTranslation:
          'اے اللہ! تیری ہی مدد سے ہم صبح کو پہنچے اور تیری ہی مدد سے ہم شام کو پہنچے، تیری ہی مرضی سے ہم زندہ رہتے ہیں اور مرتے ہیں اور تیری ہی طرف ہمیں لوٹنا ہے۔',
      reference: 'Tirmidhi 3391',
      category: 'morning',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '4',
      title: 'Tasbih for Morning',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'Subhanallahi wa bihamdihi',
      translation: 'How perfect Allah is, and I praise Him.',
      urduTranslation: 'اللہ پاک ہے اور میں اس کی حمد کرتا ہوں۔',
      reference: 'Muslim 2692',
      category: 'morning',
      isFavorite: true,
      times: 100,
    ),
    Dua(
      id: '5',
      title: 'Morning Supplication',
      arabic:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً، وَرِزْقاً طَيِّباً، وَعَمَلاً مُتَقَبَّلاً',
      transliteration:
          'Allahumma inni as\'aluka \'ilman nafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbalan',
      translation:
          'O Allah, I ask You for beneficial knowledge, goodly provision, and accepted deeds.',
      urduTranslation:
          'اے اللہ! میں تجھ سے نفع بخش علم، پاکیزہ رزق اور قبولیت والے عمل کی دعا کرتا ہوں۔',
      reference: 'Ibn Majah 925',
      category: 'morning',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '6',
      title: 'Protection from Disbelief',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ',
      transliteration: 'Allahumma inni a\'udhu bika minal-kufri wal-faqri',
      translation:
          'O Allah, I seek refuge with You from disbelief and poverty.',
      urduTranslation: 'اے اللہ! میں کفر اور فقیری سے تیری پناہ مانگتا ہوں۔',
      reference: 'Abu Dawud 5090',
      category: 'morning',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '7',
      title: 'Dua for Health',
      arabic:
          'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
      transliteration:
          'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'i, Allahumma \'afini fi basari',
      translation:
          'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight.',
      urduTranslation:
          'اے اللہ! مجھے میرے جسم میں عافیت دے، اے اللہ! مجھے میرے سننے میں عافیت دے، اے اللہ! مجھے میری بینائی میں عافیت دے۔',
      reference: 'Tirmidhi 3491',
      category: 'morning',
      isFavorite: true,
      times: 3,
    ),
    Dua(
      id: '8',
      title: 'Dua for Forgiveness',
      arabic:
          'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      transliteration:
          'Astaghfirullahal-\'adheem alladhi la ilaha illa huwal-hayyul-qayyum wa atubu ilaih',
      translation:
          'I seek the forgiveness of Allah the Mighty, Whom there is none worthy of worship except Him, the Living, the Eternal, and I repent to Him.',
      urduTranslation:
          'میں عظیم اللہ سے بخشش مانگتا ہوں جس کے سوا کوئی معبود برحق نہیں، وہی ہمیشہ زندہ رہنے والا، قائم رہنے والا ہے اور میں اسی کی طرف رجوع کرتا ہوں۔',
      reference: 'Tirmidhi 3577',
      category: 'morning',
      isFavorite: false,
      times: 100,
    ),
    Dua(
      id: '9',
      title: 'Dua for Protection',
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      transliteration:
          'Bismillahil-ladhi la yadurru ma\'asmihi shai\'un fil-ardi wa la fis-sama\'i wa huwassami\'ul-\'alim',
      translation:
          'In the name of Allah, with Whose name nothing can cause harm on earth nor in the heavens, and He is the All-Hearing, All-Knowing.',
      urduTranslation:
          'اس اللہ کے نام سے جس کے نام کے ساتھ زمین و آسمان کی کوئی چیز نقصان نہیں پہنچا سکتی، اور وہ سب کچھ سننے والا، سب کچھ جاننے والا ہے۔',
      reference: 'Abu Dawud 5088',
      category: 'morning',
      isFavorite: true,
      times: 3,
    ),
    Dua(
      id: '10',
      title: 'Dua for Blessings',
      arabic:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ',
      transliteration:
          'Allahumma inni as\'alukal-jannata wa a\'udhu bika minan-nar',
      translation:
          'O Allah, I ask You for Paradise and seek refuge with You from Hellfire.',
      urduTranslation:
          'اے اللہ! میں تجھ سے جنت مانگتا ہوں اور جہنم سے تیری پناہ چاہتا ہوں۔',
      reference: 'Abu Dawud 792',
      category: 'morning',
      isFavorite: true,
      times: 7,
    ),
    Dua(
      id: '11',
      title: 'Morning Tasbih',
      arabic:
          'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ، وَلاَ إِلَهَ إِلاَّ اللَّهُ، وَاللَّهُ أَكْبَرُ',
      transliteration:
          'Subhanallah, walhamdulillah, wa la ilaha illallah, wallahu akbar',
      translation:
          'How perfect Allah is, all praise is for Allah, none has the right to be worshipped except Allah, and Allah is the Greatest.',
      urduTranslation:
          'اللہ پاک ہے، تمام تعریف اللہ کے لیے ہے، اللہ کے سوا کوئی معبود برحق نہیں، اور اللہ سب سے بڑا ہے۔',
      reference: 'Muslim 2691',
      category: 'morning',
      isFavorite: false,
      times: 10,
    ),
    Dua(
      id: '12',
      title: 'Dua for Guidance',
      arabic:
          'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ، وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ',
      transliteration:
          'Allahumma ihdini fi man hadayta, wa \'afini fi man \'afayta, wa tawallani fi man tawallayta',
      translation:
          'O Allah, guide me among those You have guided, grant me well-being among those You have granted well-being, and take me as an ally among those You have taken as allies.',
      urduTranslation:
          'اے اللہ! مجھے ان لوگوں میں رہنمائی دے جنہیں تو نے رہنمائی دی، مجھے ان لوگوں میں عافیت دے جنہیں تو نے عافیت دی، اور مجھے ان لوگوں میں شامل کر جنہیں تو نے اپنا دوست بنایا۔',
      reference: 'Abu Dawud 1425',
      category: 'morning',
      isFavorite: false,
      times: 1,
    ),

    // Evening Duas (12)
    Dua(
      id: '13',
      title: 'Evening Remembrance 1',
      arabic:
          'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
      transliteration:
          'Amsayna wa amsal-mulku lillah, walhamdulillah, la ilaha illallah wahdahu la sharika lah',
      translation:
          'We have reached the evening and at this very time all sovereignty belongs to Allah, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner.',
      urduTranslation:
          'ہم شام کو پہنچ گئے اور اس وقت تمام بادشاہی اللہ کی ہے، اور تمام تعریف اللہ کے لیے ہے۔ اللہ کے سوا کوئی معبود برحق نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔',
      reference: 'Muslim 2723',
      category: 'evening',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '14',
      title: 'Evening Protection',
      arabic:
          'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
      transliteration:
          'Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namutu, wa ilaykal-masir',
      translation:
          'O Allah, by Your will we have reached the evening and by Your will we have reached the morning, by Your will we live and die and unto You is our return.',
      urduTranslation:
          'اے اللہ! تیری ہی مدد سے ہم شام کو پہنچے اور تیری ہی مدد سے ہم صبح کو پہنچے، تیری ہی مرضی سے ہم زندہ رہتے ہیں اور مرتے ہیں اور تیری ہی طرف ہمیں لوٹنا ہے۔',
      reference: 'Tirmidhi 3391',
      category: 'evening',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '15',
      title: 'Dua for Evening',
      arabic:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذِهِ اللَّيْلَةِ، وَأَعُوذُ بِكَ مِنْ شَرِّ هَذِهِ اللَّيْلَةِ',
      transliteration:
          'Allahumma inni as\'aluka khaira hazihil-lailati, wa a\'udhu bika min sharri hazihil-lailati',
      translation:
          'O Allah, I ask You for the good of this night and I seek refuge with You from the evil of this night.',
      urduTranslation:
          'اے اللہ! میں تجھ سے اس رات کی بھلائی مانگتا ہوں اور اس رات کے شر سے تیری پناہ چاہتا ہوں۔',
      reference: 'Abu Dawud 5066',
      category: 'evening',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '16',
      title: 'Evening Tasbih',
      arabic:
          'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',
      transliteration:
          'Subhanallahi wa bihamdihi: \'adada khalqihi, wa rida nafsihi, wa zinata \'arshihi, wa midada kalimatihi',
      translation:
          'How perfect Allah is and I praise Him by the number of His creation, His pleasure, the weight of His Throne, and the ink of His words.',
      urduTranslation:
          'اللہ پاک ہے اور میں اس کی حمد کرتا ہوں اس کی مخلوقات کی تعداد کے برابر، اس کی رضا کے برابر، اس کے عرش کے وزن کے برابر، اور اس کے کلمات کے سیاہی کے برابر۔',
      reference: 'Muslim 2726',
      category: 'evening',
      isFavorite: true,
      times: 3,
    ),

    // Sleep Duas (8)
    Dua(
      id: '17',
      title: 'Before Sleeping',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allahumma amutu wa ahya',
      translation: 'In Your name, O Allah, I die and I live.',
      urduTranslation: 'تیرے نام کے ساتھ، اے اللہ! میں مرتا ہوں اور جیتا ہوں۔',
      reference: 'Bukhari 6324',
      category: 'sleep',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '18',
      title: 'Sleep Protection',
      arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
      transliteration: 'Allahumma qini \'adhabaka yawma tab\'athu \'ibadak',
      translation:
          'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
      urduTranslation:
          'اے اللہ! مجھے اپنے عذاب سے بچانا جس دن تو اپنے بندوں کو زندہ کرے گا۔',
      reference: 'Tirmidhi 3398',
      category: 'sleep',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '19',
      title: 'Dua for Sleep',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا، وَكَفَانَا، وَآوَانَا، فَكَمْ مِمَّنْ لاَ كَافِيَ لَهُ وَلاَ مُؤْوِيَ',
      transliteration:
          'Alhamdulillahil-ladhi at\'amana wa saqana, wa kafana, wa awana, fakam mimman la kafiya lahu wa la mu\'wiya',
      translation:
          'All praise is for Allah, Who fed us and gave us drink, sufficed us and gave us shelter, for how many have none to suffice them and none to give them shelter.',
      urduTranslation:
          'تمام تعریف اس اللہ کے لیے ہے جس نے ہمیں کھلایا اور پلایا، ہمیں کافی کیا اور ہمیں پناہ دی، کتنے ہی لوگ ہیں جن کے لیے نہ کافی کرنے والا ہے اور نہ پناہ دینے والا۔',
      reference: 'Muslim 2715',
      category: 'sleep',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '20',
      title: 'Last Thing Before Sleep',
      arabic:
          'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ',
      transliteration:
          'Allahumma aslamtu nafsi ilaika, wa wajjahtu wajhi ilaika, wa fawwadtu amri ilaika',
      translation:
          'O Allah, I submit myself to You, entrust my affairs to You, turn my face to You, and rely on You.',
      urduTranslation:
          'اے اللہ! میں نے اپنے آپ کو تیرے حوالے کر دیا، اپنے معاملات تیرے سپرد کر دیے، اپنا رخ تیری طرف کر لیا اور تجھ پر بھروسہ کیا۔',
      reference: 'Bukhari 6312',
      category: 'sleep',
      isFavorite: true,
      times: 1,
    ),

    // Prayer Duas (15)
    Dua(
      id: '21',
      title: 'Opening Supplication',
      arabic:
          'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلاَ إِلَهَ غَيْرُكَ',
      transliteration:
          'Subhanaka Allahumma wa bihamdika, wa tabarakas-muka, wa ta\'ala jadduka, wa la ilaha ghairuk',
      translation:
          'How perfect You are O Allah, and I praise You. Blessed be Your name, and lofty is Your majesty. There is none worthy of worship besides You.',
      urduTranslation:
          'اے اللہ! تو پاک ہے اور میں تیری حمد کرتا ہوں۔ تیرا نام بابرکت ہے، تیری شان بلند ہے۔ تیرے سوا کوئی معبود برحق نہیں۔',
      reference: 'Abu Dawud 775',
      category: 'prayer',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '22',
      title: 'Ruku Supplication',
      arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      transliteration: 'Subhana Rabbiyal-\'Adheem',
      translation: 'How perfect my Lord is, The Supreme.',
      urduTranslation: 'میرا رب عظیم ہے، وہ پاک ہے۔',
      reference: 'Muslim 772',
      category: 'prayer',
      isFavorite: false,
      times: 3,
    ),
    Dua(
      id: '23',
      title: 'Sujood Supplication',
      arabic: 'سُبْحَانَ رَبِّيَ الأَعْلَى',
      transliteration: 'Subhana Rabbiyal-A\'la',
      translation: 'How perfect my Lord is, The Highest.',
      urduTranslation: 'میرا رب بلند ہے، وہ پاک ہے۔',
      reference: 'Muslim 772',
      category: 'prayer',
      isFavorite: false,
      times: 3,
    ),
    Dua(
      id: '24',
      title: 'Between Prostrations',
      arabic: 'رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي',
      transliteration: 'Rabbigh-fir li, Rabbigh-fir li',
      translation: 'My Lord, forgive me. My Lord, forgive me.',
      urduTranslation: 'اے میرے رب! مجھے بخش دے، اے میرے رب! مجھے بخش دے۔',
      reference: 'Ibn Majah 897',
      category: 'prayer',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '25',
      title: 'Tashahhud',
      arabic:
          'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلاَمُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ، السَّلاَمُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ',
      transliteration:
          'Attahiyyatu lillahi was-salawatu wat-tayyibat, assalamu \'alaika ayyuhan-nabiyyu wa rahmatullahi wa barakatuh, assalamu \'alaina wa \'ala \'ibadillahis-salihin',
      translation:
          'All compliments, prayers and pure words are due to Allah. Peace be upon you, O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah.',
      urduTranslation:
          'تمام تعریفیں، نمازیں اور پاکیزہ کلمات اللہ کے لیے ہیں۔ اے نبی! آپ پر سلام ہو اور اللہ کی رحمت اور اس کی برکتیں ہوں۔ ہم پر اور اللہ کے نیک بندوں پر سلام ہو۔',
      reference: 'Bukhari 835',
      category: 'prayer',
      isFavorite: true,
      times: 1,
    ),

    // Food Duas (6)
    Dua(
      id: '26',
      title: 'Before Eating',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillah',
      translation: 'In the name of Allah.',
      urduTranslation: 'اللہ کے نام سے۔',
      reference: 'Bukhari 5376',
      category: 'food',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '27',
      title: 'If Forgot to Say Bismillah',
      arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
      transliteration: 'Bismillahi awwalahu wa akhirahu',
      translation: 'In the name of Allah at the beginning and at the end.',
      urduTranslation: 'اللہ کے نام سے ابتدا میں اور آخر میں۔',
      reference: 'Abu Dawud 3767',
      category: 'food',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '28',
      title: 'After Eating',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      transliteration:
          'Alhamdulillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin',
      translation:
          'All praise is due to Allah who fed us and gave us drink and made us Muslims.',
      urduTranslation:
          'تمام تعریف اس اللہ کے لیے ہے جس نے ہمیں کھلایا اور پلایا اور ہمیں مسلمان بنایا۔',
      reference: 'Tirmidhi 3457',
      category: 'food',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '29',
      title: 'After Eating Full',
      arabic: 'الْحَمْدُ لِلَّهِ حَمْداً كَثِيراً طَيِّباً مُبَارَكاً فِيهِ',
      transliteration: 'Alhamdulillahi hamdan kathiran tayyiban mubarakan fihi',
      translation:
          'All praise is due to Allah, abundant, pure, and blessed praise.',
      urduTranslation:
          'تمام تعریف اس اللہ کے لیے ہے، بہت زیادہ، پاکیزہ اور بابرکت حمد۔',
      reference: 'Bukhari 5459',
      category: 'food',
      isFavorite: false,
      times: 1,
    ),

    // Travel Duas (8)
    Dua(
      id: '30',
      title: 'Starting Journey',
      arabic:
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
      transliteration:
          'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun',
      translation:
          'How perfect is He who has subjected this to us, and we could not have done so by ourselves. And indeed, to our Lord we will return.',
      urduTranslation:
          'وہ پاک ہے جس نے ہمارے لیے اسے مسخر کر دیا اور ہم اس پر قادر نہ تھے۔ اور بے شک ہمیں اپنے رب کی طرف لوٹنا ہے۔',
      reference: 'Quran 43:13-14',
      category: 'travel',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '31',
      title: 'When Boarding Vehicle',
      arabic:
          'بِسْمِ اللَّهِ، الْحَمْدُ لِلَّهِ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا',
      transliteration:
          'Bismillah, alhamdulillah, subhanal-ladhi sakhkhara lana hadha',
      translation:
          'In the name of Allah, all praise is due to Allah. How perfect is He who has subjected this to us.',
      urduTranslation:
          'اللہ کے نام سے، تمام تعریف اللہ کے لیے ہے۔ وہ پاک ہے جس نے ہمارے لیے اسے مسخر کر دیا۔',
      reference: 'Muslim 1342',
      category: 'travel',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '32',
      title: 'When Returning from Travel',
      arabic: 'آيِبُونَ، تَائِبُونَ، عَابِدُونَ، لِرَبِّنَا حَامِدُونَ',
      transliteration: 'A\'ibuna, ta\'ibuna, \'abiduna, li-rabbina hamidun',
      translation: 'We return repentant, worshipping, and praising our Lord.',
      urduTranslation:
          'ہم توبہ کرتے ہوئے، عبادت کرتے ہوئے اور اپنے رب کی حمد کرتے ہوئے لوٹتے ہیں۔',
      reference: 'Bukhari 3084',
      category: 'travel',
      isFavorite: true,
      times: 1,
    ),

    // Quranic Duas (10)
    Dua(
      id: '33',
      title: 'Quranic Dua for Parents',
      arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيراً',
      transliteration: 'Rabbir-hamhuma kama rabbayani saghira',
      translation:
          'My Lord, have mercy upon them as they brought me up [when I was] small.',
      urduTranslation:
          'اے میرے رب! ان پر رحم کر جیسا کہ انہوں نے مجھے چھوٹا پالا۔',
      reference: 'Quran 17:24',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '34',
      title: 'Dua for Increase in Knowledge',
      arabic: 'رَّبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni \'ilma',
      translation: 'My Lord, increase me in knowledge.',
      urduTranslation: 'اے میرے رب! میرے علم میں اضافہ فرما۔',
      reference: 'Quran 20:114',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '35',
      title: 'Dua for Good in This World and Hereafter',
      arabic:
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      transliteration:
          'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina \'adhaban-nar',
      translation:
          'Our Lord, give us in this world good and in the Hereafter good and protect us from the punishment of the Fire.',
      urduTranslation:
          'اے ہمارے رب! ہمیں دنیا میں بھلائی دے اور آخرت میں بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔',
      reference: 'Quran 2:201',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '36',
      title: 'Dua for Forgiveness and Mercy',
      arabic:
          'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
      transliteration:
          'Rabbana thalamna anfusana wa illam taghfir lana wa tarhamna lanakunanna minal-khasirin',
      translation:
          'Our Lord, we have wronged ourselves, and if You do not forgive us and have mercy upon us, we will surely be among the losers.',
      urduTranslation:
          'اے ہمارے رب! ہم نے اپنے نفسوں پر ظلم کیا، اور اگر تو ہمیں بخش دے اور ہم پر رحم کرے تو ہم ضرور نقصان اٹھانے والوں میں سے ہو جائیں گے۔',
      reference: 'Quran 7:23',
      category: 'quranic',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '37',
      title: 'Dua for Firmness',
      arabic:
          'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
      transliteration:
          'Rabbana afrigh \'alaina sabran wa thabbit aqdamana wansurna \'alal-qawmil-kafirin',
      translation:
          'Our Lord, pour upon us patience and plant firmly our feet and give us victory over the disbelieving people.',
      urduTranslation:
          'اے ہمارے رب! ہم پر صبر کی بارش کر اور ہمارے قدم جما دے اور ہمیں کافروں پر فتح دے۔',
      reference: 'Quran 2:250',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '38',
      title: 'Dua for Success',
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Rabbana taqabbal minna innaka antas-sami\'ul-\'alim',
      translation:
          'Our Lord, accept [this] from us. Indeed You are the Hearing, the Knowing.',
      urduTranslation:
          'اے ہمارے رب! ہم سے قبول فرما۔ بے شک تو سننے والا، جاننے والا ہے۔',
      reference: 'Quran 2:127',
      category: 'quranic',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '39',
      title: 'Dua for Relief from Distress',
      arabic:
          'لاَ إِلَهَ إِلاَّ أَنْتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
      transliteration: 'La ilaha illa anta subhanaka inni kuntu minaz-zalimin',
      translation:
          'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.',
      urduTranslation:
          'تیرے سوا کوئی معبود برحق نہیں، تو پاک ہے، میں ظالموں میں سے ہوں۔',
      reference: 'Quran 21:87',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '40',
      title: 'Dua for Protection from Evil',
      arabic: 'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ',
      transliteration: 'Rabbi a\'udhu bika min hamazatish-shayatin',
      translation:
          'My Lord, I seek refuge with You from the incitements of the devils.',
      urduTranslation:
          'اے میرے رب! میں شیطانوں کے وسوسوں سے تیری پناہ مانگتا ہوں۔',
      reference: 'Quran 23:97',
      category: 'quranic',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '41',
      title: 'Dua for Guidance',
      arabic:
          'رَبَّنَا لاَ تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً إِنَّكَ أَنتَ الْوَهَّابُ',
      transliteration:
          'Rabbana la tuzigh qulubana ba\'da idh hadaytana wa hab lana min ladunka rahmatan innaka antal-wahhab',
      translation:
          'Our Lord, do not let our hearts deviate after You have guided us and grant us from Yourself mercy. Indeed, You are the Bestower.',
      urduTranslation:
          'اے ہمارے رب! ہمارے دلوں کو ٹیڑھا نہ کر اس کے بعد کہ تو نے ہمیں ہدایت دے دی ہے اور ہمیں اپنی طرف سے رحمت عطا کر۔ بے شک تو ہی بہت عطا کرنے والا ہے۔',
      reference: 'Quran 3:8',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '42',
      title: 'Dua for Spouse and Children',
      arabic:
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      transliteration:
          'Rabbana hab lana min azwajina wa dhurriyatina qurrata a\'yunin waj\'alna lil-muttaqina imama',
      translation:
          'Our Lord, grant us from among our wives and offspring comfort to our eyes and make us an example for the righteous.',
      urduTranslation:
          'اے ہمارے رب! ہمیں اپنی بیویوں اور اولاد میں سے آنکھوں کی ٹھنڈک دے اور ہمیں پرہیزگاروں کا امام بنا۔',
      reference: 'Quran 25:74',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
    Dua(
      id: '43',
      title: 'Dua for Patience',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      transliteration: 'Rabbana afrigh \'alaina sabran wa tawaffana muslimin',
      translation:
          'Our Lord, pour upon us patience and let us die as Muslims [in submission to You].',
      urduTranslation:
          'اے ہمارے رب! ہم پر صبر کی بارش کر اور ہمیں مسلمان ہی موت دے۔',
      reference: 'Quran 7:126',
      category: 'quranic',
      isFavorite: false,
      times: 1,
    ),
    Dua(
      id: '44',
      title: 'Dua for Removal of Difficulties',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal-wakil',
      translation:
          'Sufficient for us is Allah, and [He is] the best Disposer of affairs.',
      urduTranslation: 'ہمارے لیے اللہ کافی ہے اور وہ بہترین کارساز ہے۔',
      reference: 'Quran 3:173',
      category: 'quranic',
      isFavorite: true,
      times: 3,
    ),
    Dua(
      id: '45',
      title: 'Dua for Acceptance of Deeds',
      arabic: 'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Rabbana taqabbal minna innaka antas-sami\'ul-\'alim',
      translation:
          'Our Lord, accept [this] from us. Indeed You are the Hearing, the Knowing.',
      urduTranslation:
          'اے ہمارے رب! ہم سے قبول فرما۔ بے شک تو سننے والا، جاننے والا ہے۔',
      reference: 'Quran 2:127',
      category: 'quranic',
      isFavorite: true,
      times: 1,
    ),
  ];

  List<Dua> get _filteredDuas {
    List<Dua> filtered = _allDuas;

    // Filter by category
    if (_categories[_selectedCategoryIndex].id != 'all') {
      filtered = filtered
          .where(
              (dua) => dua.category == _categories[_selectedCategoryIndex].id)
          .toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      filtered = filtered.where((dua) => dua.isFavorite).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((dua) {
        return dua.title.toLowerCase().contains(searchTerm) ||
            dua.arabic.toLowerCase().contains(searchTerm) ||
            dua.transliteration.toLowerCase().contains(searchTerm) ||
            dua.translation.toLowerCase().contains(searchTerm) ||
            dua.urduTranslation.toLowerCase().contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  void _toggleFavorite(int index) {
    setState(() {
      final dua = _allDuas[index];
      _allDuas[index] = Dua(
        id: dua.id,
        title: dua.title,
        arabic: dua.arabic,
        transliteration: dua.transliteration,
        translation: dua.translation,
        urduTranslation: dua.urduTranslation,
        reference: dua.reference,
        category: dua.category,
        isFavorite: !dua.isFavorite,
        times: dua.times,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF7D4E29),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 59, 42, 25),
                      Color.fromARGB(255, 73, 53, 38),
                      Color.fromARGB(255, 150, 113, 84),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 90,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Duas & Azkar',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authentic supplications for every occasion',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 78, 55, 40)),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText: 'Search Duas...',
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 192, 146, 109),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 18,
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
          ),

          // Today's Dua
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7D4E29),
                      Color(0xFFA0785A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D4037).withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Dua of the Day',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'KFGQ',
                        color: Colors.white,
                        height: 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '"Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire."',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"اے ہمارے رب! ہمیں دنیا میں بھلائی دے اور آخرت میں بھلائی دے اور ہمیں آگ کے عذاب سے بچا۔"',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Quran 2:201',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {},
                          color: Colors.white,
                        ),
                        _ActionButton(
                          icon: Icons.copy,
                          label: 'Copy',
                          onTap: () {},
                          color: Colors.white,
                        ),
                        _ActionButton(
                          icon: Icons.volume_up,
                          label: 'Listen',
                          onTap: () {},
                          color: Colors.white,
                        ),
                        _ActionButton(
                          icon: Icons.favorite_border,
                          label: 'Save',
                          onTap: () {},
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showFavoritesOnly = !_showFavoritesOnly;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _showFavoritesOnly
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _showFavoritesOnly
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: _showFavoritesOnly
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Favorites',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _showFavoritesOnly
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  size: 16,
                                  color: Color(0xFF7D4E29),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Sort',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7D4E29),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredDuas.length} Duas found',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories Horizontal List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = index == _selectedCategoryIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(
                        right: index == _categories.length - 1 ? 0 : 12,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        category.color,
                                        category.color.withOpacity(0.7),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? category.color
                                    : category.color.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: category.color.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Icon(
                                category.icon,
                                color:
                                    isSelected ? Colors.white : category.color,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? category.color
                                  : theme.textTheme.bodyLarge!.color,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${category.count}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? category.color : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Duas List Header
          if (_filteredDuas.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _categories[_selectedCategoryIndex].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        '${_filteredDuas.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7D4E29),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Duas List
          if (_filteredDuas.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final dua = _filteredDuas[index];
                  final duaIndex = _allDuas.indexWhere((d) => d.id == dua.id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: _DuaCard(
                      dua: dua,
                      onFavoriteToggle: () => _toggleFavorite(duaIndex),
                    ),
                  );
                },
                childCount: _filteredDuas.length,
              ),
            ),

          // Empty State
          if (_filteredDuas.isEmpty)
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: theme.textTheme.bodyLarge!.color!.withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Duas Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Try a different search or filter',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(0.4),
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaCard extends StatefulWidget {
  final Dua dua;
  final VoidCallback onFavoriteToggle;

  const _DuaCard({
    required this.dua,
    required this.onFavoriteToggle,
  });

  @override
  State<_DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<_DuaCard> {
  bool _showUrdu = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dua.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(widget.dua.category)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getCategoryTitle(widget.dua.category),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getCategoryColor(widget.dua.category),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    GestureDetector(
                      onTap: widget.onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.dua.isFavorite
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.dua.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.dua.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.dua.times > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.repeat,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.dua.times}x',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F0E3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8D9C5)),
              ),
              child: Text(
                widget.dua.arabic,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'KFGQ',
                  color: Color(0xFF5D4037),
                  height: 1.8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showUrdu = !_showUrdu;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _showUrdu
                      ? const Color(0xFFE8F4E8)
                      : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _showUrdu
                        ? const Color(0xFF4CAF50).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _showUrdu
                              ? 'Urdu Translation'
                              : 'English Translation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _showUrdu
                                ? const Color(0xFF4CAF50)
                                : theme.textTheme.bodyLarge!.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _showUrdu
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : const Color(0xFF7D4E29).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _showUrdu ? Icons.translate : Icons.language,
                                size: 12,
                                color: _showUrdu
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF7D4E29),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _showUrdu ? 'اردو' : 'English',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: _showUrdu
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFF7D4E29),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _showUrdu
                          ? widget.dua.urduTranslation
                          : widget.dua.translation,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: theme.textTheme.bodyLarge!.color,
                      ),
                      textDirection:
                          _showUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    if (!_showUrdu) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.dua.transliteration,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyLarge!.color!
                              .withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    widget.dua.reference,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge!.color!.withOpacity(0.6),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _DuaActionButton(
                      icon: Icons.volume_up,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _DuaActionButton(
                      icon: Icons.share,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _DuaActionButton(
                      icon: Icons.copy,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'morning':
        return Colors.orange.shade700;
      case 'evening':
        return Colors.indigo.shade700;
      case 'sleep':
        return Colors.purple.shade700;
      case 'prayer':
        return Colors.green.shade700;
      case 'food':
        return Colors.red.shade700;
      case 'travel':
        return Colors.blue.shade700;
      case 'quranic':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF7D4E29);
    }
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'morning':
        return 'Morning Azkar';
      case 'evening':
        return 'Evening Azkar';
      case 'sleep':
        return 'Before Sleep';
      case 'prayer':
        return 'Prayer Duas';
      case 'food':
        return 'Food Duas';
      case 'travel':
        return 'Travel Duas';
      case 'quranic':
        return 'Quranic Duas';
      default:
        return 'General';
    }
  }
}

class _DuaActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DuaActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFF7D4E29),
          ),
        ),
      ),
    );
  }
}
