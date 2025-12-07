import 'package:flutter/material.dart';

class AppTheme {
  // This 'static' keyword is what allows you to call AppTheme.darkTheme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Dark blue background
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.cyan,
    ),
  );

  // Define light theme too if needed
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
  );
}