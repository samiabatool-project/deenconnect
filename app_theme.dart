import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 54, 42, 24),
    primaryColorDark: const Color.fromARGB(255, 66, 55, 34),
    primaryColorLight: const Color.fromARGB(255, 136, 108, 89),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    canvasColor: Colors.white,
    cardColor: AppColors.cardLight,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 56, 41, 22),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 128, 98, 84),
      selectedItemColor: Color.fromARGB(255, 70, 50, 33),
      unselectedItemColor: AppColors.textLight,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 63, 49, 36),
      foregroundColor: Color.fromARGB(255, 128, 98, 84),
      elevation: 4,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 71, 52, 35),
        foregroundColor: const Color.fromARGB(255, 128, 98, 84),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonMedium,
        elevation: 2,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 54, 44, 28), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyles.heading1,
      displayMedium: TextStyles.heading2,
      displaySmall: TextStyles.heading3,
      bodyLarge: TextStyles.bodyLarge,
      bodyMedium: TextStyles.bodyMedium,
      bodySmall: TextStyles.bodySmall,
      labelLarge: TextStyles.buttonLarge,
      labelMedium: TextStyles.buttonMedium,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
      space: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 136, 109, 79),
    primaryColorDark: const Color.fromARGB(255, 48, 37, 21),
    primaryColorLight: const Color.fromARGB(255, 63, 52, 28),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    canvasColor: AppColors.cardDark,
    cardColor: AppColors.cardDark,

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 70, 57, 33),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardDark,
      selectedItemColor: Color.fromARGB(255, 250, 216, 193),
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 128, 102, 73),
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 71, 54, 32),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyles.buttonMedium,
        elevation: 2,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 122, 100, 68), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyles.heading1Dark,
      displayMedium: TextStyles.heading2Dark,
      displaySmall: TextStyles.heading3Dark,
      bodyLarge: TextStyles.bodyLargeDark,
      bodyMedium: TextStyles.bodyMediumDark,
      bodySmall: TextStyles.bodySmallDark,
      labelLarge: TextStyles.buttonLarge,
      labelMedium: TextStyles.buttonMedium,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: 0,
    ),
  );
}
