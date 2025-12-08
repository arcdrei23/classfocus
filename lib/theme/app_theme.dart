// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF4F6AF2);
  static const Color violet = Color(0xFF8A4FFF);
  static const Color neon = Color(0xFF00E8FF);
  static const Color background = Color(0xFFF4F6FB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFFF4F6FB),
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
  );

  static BoxDecoration glass() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.15),
      border: Border.all(color: Colors.white24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(2, 4),
        ),
      ],
      backgroundBlendMode: BlendMode.overlay,
    );
  }

  static BoxDecoration neumorphic() {
    return BoxDecoration(
      color: const Color(0xFFEFF1F5),
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          offset: Offset(-6, -6),
          blurRadius: 16,
          color: Colors.white,
        ),
        BoxShadow(
          offset: Offset(6, 6),
          blurRadius: 16,
          color: Color(0xFFBFC4CE),
        ),
      ],
    );
  }
}
