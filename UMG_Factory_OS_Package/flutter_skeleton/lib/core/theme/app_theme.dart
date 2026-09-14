import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0E1116),
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2C5F7A),
        secondary: Color(0xFF8CFF5B),
        error: Color(0xFFE5484D),
        surface: Color(0xFF171C23),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF171C23),
        centerTitle: true,
      ),
    );
  }
}
