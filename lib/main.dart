// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/quiz_provider.dart';
import 'screens/teacher/dashboard/teacher_dashboard.dart';
import 'screens/student/dashboard/student_dashboard.dart';
import 'screens/teacher/login/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with generated options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // App will still run, but Firebase features won't work
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

        // 3. Starting Screen with Firebase auth persistence and role-based routing
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData) {
              // User is logged in - fetch role and show appropriate dashboard
              return _RoleBasedDashboard(user: snapshot.data!);
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

// Widget to handle role-based dashboard routing
class _RoleBasedDashboard extends StatelessWidget {
  final User user;

  const _RoleBasedDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // Show loading while fetching user role
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user document exists, check role
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          final role = userData?['role'] as String? ?? 'student';

          if (role == 'teacher') {
            return const TeacherDashboardPage();
          } else {
            return const StudentDashboard();
          }
        }

        // Default to student dashboard if role not found
        return const StudentDashboard();
      },
    );
  }
}