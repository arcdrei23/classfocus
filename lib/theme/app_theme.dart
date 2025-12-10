// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // --- Updated Color Palette ---
  static const Color background = Color(0xFF252C4A); // Dark Navy
  static const Color surface = Color(0xFF343E63);    // Lighter Navy for Cards
  static const Color primaryBlue = Color(0xFF448AFF); // Bright Blue Accent
  static const Color secondaryText = Color(0xFF8B94BC); // Muted Blue-Grey
  static const Color white = Colors.white;

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark, // Switches text to white by default
    scaffoldBackgroundColor: background,
    fontFamily: 'Poppins',
    
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      surface: surface,
      onSurface: white,
      background: background,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: white),
      iconTheme: IconThemeData(color: white),
    ),

    // Input Decoration for Search Bar
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: const TextStyle(color: secondaryText),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: secondaryText,
    ),
  );
}