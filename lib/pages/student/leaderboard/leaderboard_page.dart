import 'package:flutter/material.dart';
// import 'package:confetti/confetti.dart'; // Uncomment when confetti package is added
import '../../../data/dummy_leaderboard.dart';
import '../../../models/leaderboard_entry.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String filter = "All-Time";
  // late ConfettiController confettiController; // Uncomment when confetti package is added

  @override
  void initState() {
    super.initState();
    // Uncomment when confetti package is added:
    // confettiController =
    //     ConfettiController(duration: const Duration(seconds: 2));
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   confettiController.play();
    // });
  }

  @override
  void dispose() {
    // confettiController.dispose(); // Uncomment when confetti package is added
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f1c),
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildFilters(),
          _buildList(),
          // Uncomment when confetti package is added:
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: ConfettiWidget(
          //     confettiController: confettiController,
          //     blastDirection: 3.14 / 2,
          //     emissionFrequency: 0.05,
          //     numberOfParticles: 20,
          //     gravity: 0.3,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ["Daily", "Weekly", "Monthly", "All-Time"];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final f = filters[i];
          final selected = filter == f;

          return GestureDetector(
            onTap: () {
              setState(() => filter = f);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    if (dummyLeaderboard.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 70),
        child: const Center(
          child: Text(
            "No leaderboard data available",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: ListView.builder(
        itemCount: dummyLeaderboard.length,
        itemBuilder: (context, i) {
          final student = dummyLeaderboard[i];
          return _buildEntry(student);
        },
      ),
    );
  }

  Widget _buildEntry(LeaderboardEntry s) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/studentProfile", arguments: s);
      },
      child: Hero(
        tag: "avatar_${s.id}",
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff1b1b2e),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank number
              Text(
                "#${s.rank}",
                style: TextStyle(
                  color: s.rank == 1 ? Colors.yellowAccent : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),

              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blueAccent.withOpacity(0.3),
                backgroundImage: AssetImage(s.avatarUrl),
                onBackgroundImageError: (_, __) {},
                child: s.avatarUrl.isEmpty
                    ? Text(
                        s.studentName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.studentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      s.className,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // XP Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: (s.xp % 1000) / 1000,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // XP
              Column(
                children: [
                  const Icon(Icons.star, color: Colors.yellowAccent),
                  Text(
                    "${s.xp}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
