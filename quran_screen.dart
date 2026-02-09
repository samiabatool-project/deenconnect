import 'package:flutter/material.dart';
import 'package:deen_connect/core/theme/app_colors.dart';
import 'package:deen_connect/services/quran_service.dart';
import 'package:deen_connect/data/models/surah_model.dart';
import 'package:deen_connect/data/models/ayah_model.dart';
import 'package:shimmer/shimmer.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<List<Surah>> futureSurahs;
  final QuranService _quranService = QuranService();
  List<Surah> _filteredSurahs = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _totalAyahs = 0;
  int _totalSurahs = 0;

  @override
  void initState() {
    super.initState();
    _loadQuranData();
  }

  Future<void> _loadQuranData() async {
    futureSurahs = _quranService.getAllSurahs();

    futureSurahs.then((surahs) {
      if (surahs.isNotEmpty) {
        setState(() {
          _filteredSurahs = List.from(surahs);
          _totalSurahs = surahs.length;
          _totalAyahs =
              surahs.fold(0, (sum, surah) => sum + surah.numberOfAyahs);
        });
      }
    }).catchError((error) {
      print("Error loading data: $error");
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredSurahs = [];
      });
      _loadQuranData();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    futureSurahs.then((surahs) {
      if (surahs.isNotEmpty) {
        final localResults = surahs.where((surah) {
          return surah.englishName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              surah.englishNameTranslation
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              surah.name.contains(query);
        }).toList();

        setState(() {
          _filteredSurahs = localResults;
        });
      }
    });
  }

  void _navigateToSurahDetail(Surah surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahDetailScreen(surah: surah),
      ),
    );
  }

  void _sortSurahs(String type) {
    List<Surah> surahsToSort = _isSearching ? _filteredSurahs : _filteredSurahs;

    setState(() {
      surahsToSort.sort((a, b) {
        switch (type) {
          case 'name':
            return a.englishName.compareTo(b.englishName);
          case 'ayahs':
            return b.numberOfAyahs.compareTo(a.numberOfAyahs);
          case 'type':
            return a.revelationType.compareTo(b.revelationType);
          default:
            return a.number.compareTo(b.number);
        }
      });

      if (_isSearching) {
        _filteredSurahs = surahsToSort;
      } else {
        _filteredSurahs = surahsToSort;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 75, 50, 34),
            expandedHeight: 240,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 80,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The Holy Quran',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<List<Surah>>(
                        future: futureSurahs,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Text(
                              '${snapshot.data!.length} Surahs • $_totalAyahs Ayahs',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.search,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search Surah or Ayah...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white70,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            _onSearchChanged('');
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.play_circle_fill,
                          label: 'Listen',
                          color: const Color.fromARGB(255, 51, 41, 26),
                          onTap: () => _showAudioPlayer(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.bookmark_border,
                          label: 'Bookmarks',
                          color: const Color.fromARGB(255, 51, 41, 26),
                          onTap: () => _showBookmarks(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.history,
                          label: 'Recent',
                          color: const Color.fromARGB(255, 51, 41, 26),
                          onTap: () => _showRecentRead(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Featured Surahs
                  const Text(
                    'Featured Surahs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: FutureBuilder<List<Surah>>(
                      future: futureSurahs,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildFeaturedShimmer();
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.hasData) {
                          final surahs = snapshot.data!;
                          // Ensure we have enough surahs
                          if (surahs.length >= 67) {
                            final featuredSurahs = [
                              surahs.firstWhere((s) => s.number == 36),
                              surahs.firstWhere((s) => s.number == 67),
                              surahs.firstWhere((s) => s.number == 55),
                              surahs.firstWhere((s) => s.number == 1),
                            ];

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredSurahs.length,
                              itemBuilder: (context, index) {
                                final surah = featuredSurahs[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index < featuredSurahs.length - 1
                                        ? 12
                                        : 0,
                                  ),
                                  child: _FeaturedSurahCard(
                                    number: surah.number,
                                    arabicName: surah.name,
                                    name: surah.englishName,
                                    ayahs: surah.numberOfAyahs,
                                    onTap: () => _navigateToSurahDetail(surah),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('Insufficient data'),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Surah List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isSearching
                        ? 'Search Results (${_filteredSurahs.length})'
                        : 'All Surahs ($_totalSurahs)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: _sortSurahs,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'number',
                        child: Text('By Number'),
                      ),
                      const PopupMenuItem(
                        value: 'name',
                        child: Text('By Name'),
                      ),
                      const PopupMenuItem(
                        value: 'ayahs',
                        child: Text('By Ayahs'),
                      ),
                      const PopupMenuItem(
                        value: 'type',
                        child: Text('By Type'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.sort,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Surah List
          FutureBuilder<List<Surah>>(
            future: futureSurahs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildSurahShimmer(),
                    childCount: 10,
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load Quran data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadQuranData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                final surahsToShow =
                    _isSearching ? _filteredSurahs : snapshot.data!;

                if (surahsToShow.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.grey[400],
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSearching
                                ? 'No results found'
                                : 'No surahs available',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final surah = surahsToShow[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: _SurahCard(
                          surah: surah,
                          onTap: () => _navigateToSurahDetail(surah),
                        ),
                      );
                    },
                    childCount: surahsToShow.length,
                  ),
                );
              }

              return const SliverToBoxAdapter(
                child: SizedBox(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 3 ? 12 : 0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showAudioPlayer() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Audio Player',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Add audio player UI here
          ],
        ),
      ),
    );
  }

  void _showBookmarks() {
    // Implement bookmarks functionality
  }

  void _showRecentRead() {
    // Implement recent read functionality
  }
}

// Surah Detail Screen
class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late Future<List<Ayah>> futureAyahs;
  final QuranService _quranService = QuranService();

  @override
  void initState() {
    super.initState();
    futureAyahs = _quranService.getSurahAyahs(widget.surah.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah.englishName,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.surah.englishNameTranslation,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Ayah>>(
        future: futureAyahs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load Surah',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureAyahs =
                            _quranService.getSurahAyahs(widget.surah.number);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            final ayahs = snapshot.data!;
            if (ayahs.isEmpty) {
              return const Center(
                child: Text('No ayahs found for this surah'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ayahs.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _SurahHeader(surah: widget.surah);
                }
                final ayah = ayahs[index - 1];
                return _AyahCard(ayah: ayah);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;

  const _SurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Arabic',
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            surah.name,
            style: const TextStyle(
              fontSize: 40,
              fontFamily: 'Arabic',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            surah.englishName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            surah.englishNameTranslation,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                backgroundColor: surah.revelationType == 'Meccan'
                    ? const Color.fromARGB(255, 61, 49, 32).withOpacity(0.2)
                    : const Color.fromARGB(255, 114, 99, 67).withOpacity(0.2),
                label: Text(
                  surah.revelationType,
                  style: TextStyle(
                    color: surah.revelationType == 'Meccan'
                        ? const Color.fromARGB(255, 61, 49, 32)
                        : const Color.fromARGB(255, 114, 99, 67),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                backgroundColor: Colors.blue.withOpacity(0.2),
                label: Text(
                  '${surah.numberOfAyahs} Ayahs',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  final Ayah ayah;

  const _AyahCard({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ayah.numberInSurah.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_border,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ayah.text,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Arabic',
              height: 1.8,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              ayah.translation,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Original Widgets
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSurahCard extends StatelessWidget {
  final int number;
  final String arabicName;
  final String name;
  final int ayahs;
  final VoidCallback onTap;

  const _FeaturedSurahCard({
    required this.number,
    required this.arabicName,
    required this.name,
    required this.ayahs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              arabicName,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: 'Arabic',
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$ayahs Ayahs',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                surah.number.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.englishNameTranslation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Arabic',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: surah.revelationType == 'Meccan'
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    surah.revelationType,
                    style: TextStyle(
                      fontSize: 12,
                      color: surah.revelationType == 'Meccan'
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${surah.numberOfAyahs} Ayahs',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
