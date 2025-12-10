// lib/screens/student/dashboard/tabs/quiz_tab.dart
import 'package:flutter/material.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "/quizUnlock"),
        child: const Text("Take Quiz"),
      ),
    );
  }
}
