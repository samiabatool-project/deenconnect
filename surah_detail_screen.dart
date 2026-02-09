import 'package:flutter/material.dart';
import 'package:deen_connect/core/theme/app_colors.dart';
import 'package:deen_connect/data/models/surah_model.dart';
import 'package:deen_connect/data/models/ayah_model.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final List<Ayah> ayahs;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    required this.ayahs,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _itemsPerPage = 15; // Ayahs per page

  List<List<Ayah>> get _paginatedAyahs {
    List<List<Ayah>> pages = [];
    for (int i = 0; i < widget.ayahs.length; i += _itemsPerPage) {
      int end = (i + _itemsPerPage < widget.ayahs.length)
          ? i + _itemsPerPage
          : widget.ayahs.length;
      pages.add(widget.ayahs.sublist(i, end));
    }
    return pages;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _paginatedAyahs;
    final totalPages = pages.length;

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 231, 213, 172), // Parchment-like background
      body: Column(
        children: [
          // Custom App Bar
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.surah.englishName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.surah.englishNameTranslation,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Juz and Page Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildJuzInfo(),
                        const SizedBox(height: 4),
                        Text(
                          'Page ${_currentPage + 1}/$totalPages',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(179, 238, 210, 184),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Page View for Ayahs
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final ayahs = pages[pageIndex];
                return _buildAyahPage(ayahs, pageIndex);
              },
            ),
          ),

          // Page Navigation Controls
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 155, 130, 101),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  ElevatedButton.icon(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 61, 46, 28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  // Page Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 68, 51, 32)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / $totalPages',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 59, 40, 27),
                      ),
                    ),
                  ),

                  // Next Button
                  ElevatedButton.icon(
                    onPressed: _currentPage < totalPages - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 41, 26),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button for Quick Actions
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActions,
        backgroundColor: const Color.fromARGB(255, 97, 72, 52),
        foregroundColor: Colors.white,
        child: const Icon(Icons.menu_book),
      ),
    );
  }

  Widget _buildJuzInfo() {
    // Calculate which juz the current page belongs to
    // You can implement actual juz calculation based on ayah numbers
    int juzNumber = (_currentPage % 30) + 1; // Simplified calculation

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bookmark_border,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            'Juz $juzNumber',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahPage(List<Ayah> ayahs, int pageIndex) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Page Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 35, 21).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surah ${widget.surah.englishName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 41, 27, 17),
                      ),
                    ),
                    Text(
                      'Ayahs ${ayahs.first.numberInSurah} - ${ayahs.last.numberInSurah}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 131, 97, 69),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Page ${pageIndex + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 37, 32, 19),
                      ),
                    ),
                    Text(
                      'Juz ${((pageIndex % 30) + 1)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 109, 80, 61),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bismillah for first page
          if (pageIndex == 0 &&
              widget.surah.number != 9 &&
              widget.surah.number != 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Uthmanic',
                      color: Color.fromARGB(255, 54, 39, 21),
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 2,
                    color:
                        const Color.fromARGB(255, 80, 64, 46).withOpacity(0.3),
                  ),
                ],
              ),
            ),

          // Ayahs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return _buildAyahCard(ayah, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(Ayah ayah, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Ayah Number and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ayah Number with Ruku indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 92, 73, 48).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 70, 53, 31),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          ayah.numberInSurah.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ayah ${ayah.numberInSurah}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 46, 30, 19),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Row(
                children: [
                  // Bookmark
                  IconButton(
                    onPressed: () => _toggleBookmark(ayah),
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Color.fromARGB(255, 46, 36, 18),
                      size: 20,
                    ),
                  ),
                  // Play Audio
                  IconButton(
                    onPressed: () => _playAyahAudio(ayah),
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color.fromARGB(255, 34, 24, 13),
                      size: 20,
                    ),
                  ),
                  // Share
                  IconButton(
                    onPressed: () => _shareAyah(ayah),
                    icon: const Icon(
                      Icons.share,
                      color: Color.fromARGB(255, 34, 24, 13),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Arabic Text with Beautiful Design
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 44, 33, 17).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Arabic Text
                Text(
                  ayah.text,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Uthmanic',
                    color: Color(0xFF2C3E50),
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Decorative Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 53, 42, 22).withOpacity(0.1),
                        const Color.fromARGB(255, 105, 74, 54).withOpacity(0.3),
                        const Color.fromARGB(255, 65, 49, 32).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Translation with Juz Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Translation Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Translation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // Juz and Page Info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Juz ${(ayah.number ~/ 20) + 1} • Page ${(ayah.number ~/ 10) + 1}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Translation Text
                Text(
                  ayah.translation.isNotEmpty
                      ? ayah.translation
                      : 'Translation will appear here',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF34495E),
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                // Ruku Info (if available)
                if (ayah.ruku != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Ruku ${ayah.ruku}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Sajda Indicator
          if (ayah.sajda)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.purple,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Sajda',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Action Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildQuickAction(
                  icon: Icons.bookmark_add,
                  label: 'Bookmark',
                  color: Colors.orange,
                ),
                _buildQuickAction(
                  icon: Icons.play_circle_fill,
                  label: 'Listen',
                  color: Colors.green,
                ),
                _buildQuickAction(
                  icon: Icons.share,
                  label: 'Share',
                  color: Colors.blue,
                ),
                _buildQuickAction(
                  icon: Icons.text_fields,
                  label: 'Text Size',
                  color: Colors.purple,
                ),
                _buildQuickAction(
                  icon: Icons.nightlight_round,
                  label: 'Theme',
                  color: Colors.indigo,
                ),
                _buildQuickAction(
                  icon: Icons.download,
                  label: 'Download',
                  color: Colors.teal,
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _toggleBookmark(Ayah ayah) {
    // Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarked Ayah ${ayah.numberInSurah}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _playAyahAudio(Ayah ayah) {
    // Implement audio playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing audio for Ayah ${ayah.numberInSurah}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareAyah(Ayah ayah) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing Ayah ${ayah.numberInSurah}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
