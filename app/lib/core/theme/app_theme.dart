import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Inter', // Remove if you don't have Inter font
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    // 
    // cardTheme: CardTheme(
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    // ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF6366F1),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF1F2937),
    ),
    scaffoldBackgroundColor: const Color(0xFF111827),
  );
}