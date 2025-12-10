import 'package:flutter/material.dart';
import '../../models/leaderboard_entry.dart';

class StudentProfilePage extends StatelessWidget {
  final LeaderboardEntry student;

  const StudentProfilePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f1c),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Student Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Hero(
              tag: "avatar_${student.id}",
              child: CircleAvatar(
                radius: 60,
                backgroundImage: student.avatarUrl.startsWith('http')
                    ? NetworkImage(student.avatarUrl) as ImageProvider
                    : AssetImage(student.avatarUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              student.studentName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              student.className,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // XP / Streak / Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat("XP", student.xp.toString()),
                _stat("Streak", student.streak.toString()),
                _stat("Progress", "${(student.progress * 100).toStringAsFixed(0)}%"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
