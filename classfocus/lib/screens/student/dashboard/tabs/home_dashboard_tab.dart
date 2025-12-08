// lib/screens/student/dashboard/tabs/home_dashboard_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class HomeDashboardTab extends StatelessWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 24),
              _buildBannerCard(context),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildSubjectsSection(context),
              const SizedBox(height: 24),
              _buildRecentActivityList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryBlue, width: 2),
              ),
              // --- FIXED SECTION: Safe Image Loading ---
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.surface,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Show this icon if image is missing, preventing crash
                      return const Icon(Icons.person, color: Colors.white);
                    },
                  ),
                ),
              ),
              // ----------------------------------------
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Student Name", 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white 
                  )
                ),
                Text(
                  "Grade 6 - Einstein", 
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 13)
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface, 
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.star_rounded, color: Colors.orange, size: 22),
              SizedBox(width: 6),
              Text(
                "1,250 XP", 
                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ... (Keep the rest of your methods: _buildBannerCard, _buildSearchBar, etc. exactly the same)
  // Just make sure you are using the version I gave you previously that uses the Dark Theme colors.
  
  Widget _buildBannerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryBlue, 
            Color(0xFF8A4FFF) 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Test Your Knowledge\nwith Subject Quizzes",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/quizUnlock'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text("Play Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
          Icon(Icons.emoji_events_rounded, color: Colors.white.withOpacity(0.9), size: 90),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white), 
      decoration: InputDecoration(
        hintText: "Search subjects...",
        hintStyle: const TextStyle(color: AppTheme.secondaryText),
        prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryText),
        filled: true,
        fillColor: AppTheme.surface, 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSubjectsSection(BuildContext context) {
    // IT Subjects as per requirements
    final subjects = [
      {
        "name": "Data Structures",
        "icon": Icons.storage,
        "color": Colors.pink,
      },
      {
        "name": "Networking",
        "icon": Icons.router,
        "color": Colors.lightBlue,
      },
      {
        "name": "Database Systems",
        "icon": Icons.dns,
        "color": Colors.purple,
      },
      {
        "name": "Web Dev",
        "icon": Icons.code,
        "color": Colors.cyan,
      },
      {
        "name": "HCI",
        "icon": Icons.people,
        "color": Colors.orange,
      },
      {
        "name": "OS",
        "icon": Icons.memory,
        "color": Colors.green,
      },
      {
        "name": "OOP",
        "icon": Icons.view_module,
        "color": Colors.yellow,
      },
      {
        "name": "Capstone",
        "icon": Icons.rocket_launch,
        "color": Colors.deepPurple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Subjects",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final sub = subjects[index];
            return GestureDetector(
              onTap: () {
                // Navigate to subject detail screen with subject name
                Navigator.pushNamed(
                  context,
                  '/subjectDetail',
                  arguments: sub['name'] as String,
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(sub['icon'] as IconData, color: sub['color'] as Color, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sub['name'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.secondaryText),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildActivityItem("Math Quiz", "24/30", Colors.blue),
        _buildActivityItem("Science Quiz", "28/30", Colors.green),
      ],
    );
  }

  Widget _buildActivityItem(String title, String score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.assignment_turned_in, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text("Completed just now", style: TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          Text(score, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}