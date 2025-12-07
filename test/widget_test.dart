import 'package:flutter/material.dart';

class AppTheme {
  // 1. It must be 'static' so you can access it as AppTheme.darkTheme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Dark blue background
    useMaterial3: true,
    // Add other styles here
  );

  // You might also have a light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
  );
}