import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static const Color _obsidian = Color(0xFF101318);
  static const Color _surfaceDark = Color(0xFF171B21);
  static const Color _steelBlue = Color(0xFF2A3A4D);
  static const Color _cyberLime = Color(0xFF9BEA4B);
  static const Color _infraredRed = Color(0xFFE5484D);
  static const Color _burntOrange = Color(0xFFE07A1F);
  static const Color _corporateBlue = Color(0xFF2D6CDF);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _obsidian,
      colorScheme: const ColorScheme.dark(
        primary: _corporateBlue,
        secondary: _cyberLime,
        error: _infraredRed,
        surface: _surfaceDark,
      ),
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: _steelBlue, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _obsidian,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _steelBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _steelBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _corporateBlue, width: 1.4),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.5),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _corporateBlue,
        secondary: _cyberLime,
        error: _infraredRed,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE6EBF2), width: 1),
        ),
      ),
    );
  }
}
