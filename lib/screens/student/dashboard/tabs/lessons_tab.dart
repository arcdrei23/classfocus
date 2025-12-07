// lib/screens/student/dashboard/tabs/lessons_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class LessonsTab extends StatelessWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text(
            "Your Classes",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _classCard(
            title: "Math 6",
            subtitle: "Algebra & Fractions",
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
          const SizedBox(height: 18),

          _classCard(
            title: "Science 6",
            subtitle: "Earth, Life, Physical",
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
          const SizedBox(height: 18),

          _classCard(
            title: "English 6",
            subtitle: "Vocabulary & Grammar",
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
        ],
      ),
    );
  }

  Widget _classCard(
      {required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryBlue, AppTheme.violet],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.class_, color: Colors.white, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
