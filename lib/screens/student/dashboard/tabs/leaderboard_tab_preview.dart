// lib/screens/student/dashboard/tabs/leaderboard_tab_preview.dart
import 'package:flutter/material.dart';

class LeaderboardTabPreview extends StatelessWidget {
  const LeaderboardTabPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "/leaderboard"),
        child: const Text("View Leaderboard"),
      ),
    );
  }
}
