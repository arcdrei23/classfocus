// lib/screens/student/dashboard/tabs/timer_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class TimerTab extends StatelessWidget {
  const TimerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Pomodoro Timer",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.violet],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "25:00",
                style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 40),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/pomodoro"),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Start Timer",
                style: TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
