import 'package:flutter/material.dart';
import '../../../data/dummy_badges.dart';
import '../../../models/badge.dart' as models;

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage>
    with SingleTickerProviderStateMixin {
  int totalXP = 520;         // You can replace with backend values
  int streak = 7;            // You can replace with backend values
  late AnimationController bounceController;

  @override
  void initState() {
    super.initState();

    bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: 0.85,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _checkUnlocks();
  }

  @override
  void dispose() {
    bounceController.dispose();
    super.dispose();
  }

  /// Unlock badges based on XP and streak
  void _checkUnlocks() {
    for (var badge in dummyBadges) {
      if (totalXP >= badge.requiredXP &&
          streak >= badge.requiredStreak &&
          !badge.unlocked) {
        setState(() => badge.unlocked = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f1c),
      appBar: AppBar(
        title: const Text("Badges"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: dummyBadges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (_, i) => _buildBadge(dummyBadges[i]),
        ),
      ),
    );
  }

  Widget _buildBadge(models.Badge badge) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/badgeDetails",
          arguments: badge,
        );
      },
      child: ScaleTransition(
        scale: badge.unlocked
            ? CurvedAnimation(
                parent: bounceController,
                curve: Curves.easeInOut,
              )
            : const AlwaysStoppedAnimation(1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: badge.unlocked
                ? const LinearGradient(
                    colors: [
                      Color(0xff6a00ff),
                      Color(0xff0099ff),
                    ],
                  )
                : null,
            color: badge.unlocked
                ? null
                : Colors.white.withOpacity(0.08),
            boxShadow: badge.unlocked
                ? [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: badge.unlocked ? 1 : 0.3,
                child: Image.asset(
                  badge.icon,
                  height: 60,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: badge.unlocked
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
