import 'package:flutter/material.dart';
import '../../../data/dummy_leaderboard.dart';
import '../../../models/leaderboard_entry.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Leaderboard'),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final entries = [...dummyLeaderboard]..sort((a, b) => a.rank.compareTo(b.rank));
          final currentName = authService.currentUser?.name ?? 'You';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildPodium(entries),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'All Ranks',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...entries.map((e) => _buildRow(e, highlight: e.studentName == currentName)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> entries) {
    final top3 = entries.take(3).toList();
    while (top3.length < 3) {
      top3.add(LeaderboardEntry(
        id: 'x',
        rank: top3.length + 1,
        studentName: 'TBD',
        className: '',
        xp: 0,
        streak: 0,
        avatarUrl: 'assets/images/logo.png',
        progress: 0,
      ));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: top3.map((e) => _podiumTile(e)).toList(),
      ),
    );
  }

  Widget _podiumTile(LeaderboardEntry entry) {
    final colors = [Colors.amber, Colors.blueGrey, Colors.brown];
    final color = colors[(entry.rank - 1).clamp(0, 2)];

    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          backgroundImage: AssetImage(entry.avatarUrl),
          child: Text(entry.studentName[0]),
        ),
        const SizedBox(height: 8),
        Text(
          '#${entry.rank}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.studentName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${entry.xp} XP',
          style: const TextStyle(color: AppTheme.secondaryText),
        ),
      ],
    );
  }

  Widget _buildRow(LeaderboardEntry entry, {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.primaryBlue.withOpacity(0.2) : AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppTheme.primaryBlue : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Text(
            '${entry.rank}',
            style: TextStyle(
              color: highlight ? Colors.white : AppTheme.secondaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundImage: AssetImage(entry.avatarUrl),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.studentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  entry.className,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.xp} XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Streak: ${entry.streak}',
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}