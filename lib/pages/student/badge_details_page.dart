import 'package:flutter/material.dart';
import '../../../models/badge.dart' as models;

class BadgeDetailsPage extends StatelessWidget {
  final models.Badge badge;

  const BadgeDetailsPage({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f1c),
      appBar: AppBar(
        title: Text(badge.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              badge.icon,
              height: 120,
              opacity: badge.unlocked
                  ? const AlwaysStoppedAnimation(1.0)
                  : const AlwaysStoppedAnimation(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              badge.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              badge.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildRequirement("Required XP", badge.requiredXP),
            _buildRequirement("Required Streak", badge.requiredStreak),
            const SizedBox(height: 40),
            Text(
              badge.unlocked ? "Unlocked!" : "Locked",
              style: TextStyle(
                fontSize: 20,
                color: badge.unlocked
                    ? Colors.greenAccent
                    : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
