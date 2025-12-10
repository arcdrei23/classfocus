// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/quiz_provider.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await FirebaseService.initialize();
  } catch (e) {
    print('Firebase initialization error: $e');
    // App will still run, but Firebase features won't work
    // Make sure to add google-services.json (Android) and GoogleService-Info.plist (iOS)
  }
  
  runApp(const ClassFocusApp());
}

class ClassFocusApp extends StatelessWidget {
  const ClassFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: 'ClassFocus',
        debugShowCheckedModeBanner: false,

        // 1. Theme Configuration
        theme: AppTheme.darkTheme,

        // 2. Navigation Routes
        // This connects to your routes.dart file to handle all page navigation
        onGenerateRoute: AppRoutes.generateRoute,

        // 3. Starting Screen
        // The app will open to the Login Selection page where users can choose Student or Teacher
        initialRoute: '/loginSelection',
      ),
    );
  }
}