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
            style: TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.bold,
              color: Colors.white // Fixed: Visible on dark background
            ),
          ),
          const SizedBox(height: 16),

          _classCard(
            title: "Math 6",
            subtitle: "Algebra & Fractions",
            color: Colors.blue, // Feature color
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
          const SizedBox(height: 18),

          _classCard(
            title: "Science 6",
            subtitle: "Earth, Life, Physical",
            color: Colors.green, // Feature color
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
          const SizedBox(height: 18),

          _classCard(
            title: "English 6",
            subtitle: "Vocabulary & Grammar",
            color: Colors.orange, // Feature color
            onTap: () => Navigator.pushNamed(context, "/classList"),
          ),
        ],
      ),
    );
  }

  Widget _classCard({
    required String title, 
    required String subtitle, 
    required Color color, // Added color parameter for variety
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface, // Fixed: Use dark theme card color
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          // Optional: Add a subtle border
          border: Border.all(color: Colors.white.withOpacity(0.05)), 
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.class_, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Fixed text color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.secondaryText, // Fixed secondary text color
                      fontSize: 14
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}