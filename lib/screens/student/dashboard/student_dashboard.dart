// lib/screens/student/dashboard/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/app_theme.dart';
import '../../../models/quiz_model.dart';
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
    const HomeDashboardTab(),
    const SubjectsTab(),
    const TimerTab(),
    MessagesTab(),
    const ProfileTab(),
  ];

  void _showJoinQuizDialog() {
    final codeController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Join Quiz with Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the 6-character code provided by your teacher:'),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  hintText: 'e.g., ABC123',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final code = codeController.text.trim().toUpperCase();

                      if (code.isEmpty || code.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid 6-character code')),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        // Query Firestore for quiz with matching access code
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('quizzes')
                            .where('accessCode', isEqualTo: code)
                            .get();

                        if (querySnapshot.docs.isEmpty) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid Code'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                          return;
                        }

                        // Quiz found - convert to QuizModel and navigate
                        final quizDoc = querySnapshot.docs.first;
                        final quizData = quizDoc.data();
                        final quiz = QuizModel.fromMap(quizData);

                        if (mounted) {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/quizStart',
                            arguments: quiz,
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
              ),
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showJoinQuizDialog,
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.keyboard),
        label: const Text('Join Quiz'),
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