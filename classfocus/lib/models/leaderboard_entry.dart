// lib/models/leaderboard_entry.dart

class LeaderboardEntry {
  final String id;
  final int rank;
  final String studentName;
  final String className;
  final int xp;
  final int streak;
  final String avatarUrl;
  final double progress; // improvement %

  LeaderboardEntry({
    required this.id,
    required this.rank,
    required this.studentName,
    required this.className,
    required this.xp,
    required this.streak,
    required this.avatarUrl,
    required this.progress,
  });
}

