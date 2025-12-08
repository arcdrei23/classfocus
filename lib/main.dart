// lib/main.dart (root of repo)
// This is a placeholder entrypoint. The real app lives in /classfocus.
import 'package:flutter/material.dart';

void main() {
  runApp(const PlaceholderApp());
}

class PlaceholderApp extends StatelessWidget {
  const PlaceholderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Start the app from the classfocus/ directory:\n'
            '  cd classfocus && flutter run',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}