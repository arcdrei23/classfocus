import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

// STUDENT SCREENS
import 'screens/student/login_page.dart';
import 'screens/student/register_page.dart';
import 'screens/student/dashboard/student_dashboard.dart';

// TEACHER SCREENS
import 'screens/teacher/login/teacher_login_page.dart'; // Correct path
import 'screens/teacher/dashboard/teacher_dashboard.dart'; // Correct path

// DASHBOARD TABS
import 'screens/student/dashboard/tabs/home_dashboard_tab.dart';

void main() {
  runApp(const ClassFocusApp());
}

class ClassFocusApp extends StatelessWidget {
  const ClassFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassFocus',
      debugShowCheckedModeBanner: false,
      
      // Use your custom theme


      // 🌟 Landing page when app opens
      initialRoute: '/studentLogin',

      routes: {
        // --- STUDENT ROUTES ---
        '/studentLogin': (context) => const StudentLoginPage(),
        '/studentRegister': (context) => const StudentRegisterPage(),
        '/studentDashboard': (context) => const StudentDashboard(),
        '/homeDashboard': (context) => const HomeDashboardTab(),

        // --- TEACHER ROUTES ---
        '/teacherLogin': (context) => const TeacherLoginPage(),
        '/teacherDashboard': (context) => const TeacherDashboardPage(),
        
        // Note: You haven't created 'TeacherRegisterPage' yet. 
        // You can point this to the generic RegisterPage if you want:
        // '/teacherRegister': (context) => const RegisterPage(),
      },
    );
  }
}