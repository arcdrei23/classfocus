// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imports from your project structure
import 'routes.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/quiz_provider.dart';
import 'services/dev_data_service.dart';
import 'firebase_options.dart'; // Ensure you have run 'flutterfire configure'

// Screen Imports
import 'screens/teacher/dashboard/teacher_dashboard.dart';
import 'screens/student/dashboard/student_dashboard.dart';
import 'screens/auth/login_selection_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.signOut();
    
    // Initialize dev data (student + teacher accounts + sample quizzes)
    await DevDataService.initializeDevData();
  } catch (e) {
    print('Firebase initialization error: $e');
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
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRoutes.generateRoute,

        // Persistent Login Logic
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // 1. Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // 2. User is logged in
            if (snapshot.hasData) {
              return _RoleBasedDashboard(user: snapshot.data!);
            }

            // 3. User is NOT logged in (Go to selection page)
            return const LoginSelectionPage();
          },
        ),
      ),
    );
  }
}

class _RoleBasedDashboard extends StatefulWidget {
  final User user;

  const _RoleBasedDashboard({required this.user});

  @override
  State<_RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<_RoleBasedDashboard> {
  @override
  void initState() {
    super.initState();
    // Load user data from Firestore
    Future.microtask(() {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.loadUserFromFirestore(widget.user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          final role = userData?['role'] as String? ?? 'student';

          if (role == 'teacher') {
            return const TeacherDashboardPage();
          } else {
            return const StudentDashboard();
          }
        }

        // Default fallback
        return const StudentDashboard();
      },
    );
  }
}
