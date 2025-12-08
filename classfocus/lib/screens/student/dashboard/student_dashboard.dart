// lib/screens/student/dashboard/student_dashboard.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'tabs/home_dashboard_tab.dart'; // Import the new home tab
import 'tabs/subjects_tab.dart';
import 'tabs/timer_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/messages_tab.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeDashboardTab(), // Screen 1
    const SubjectsTab(), // Subjects Tab with available quizzes
    const TimerTab(),
    MessagesTab(), // Messages instead of Favorites
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack( // Keeps state of tabs alive
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Subjects"),
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Pomodoro"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Messages"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}