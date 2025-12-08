// lib/screens/student/dashboard/tabs/home_dashboard_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class HomeDashboardTab extends StatelessWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background is handled by the Theme, but we can be explicit if needed
      backgroundColor: AppTheme.background, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- User Header ---
              Row(
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
                        child: const CircleAvatar(
                          radius: 24,
                          // Ensure this image exists in your assets/images/ folder
                          backgroundImage: AssetImage('assets/images/logo.png'), 
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Hi, Student", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.white)),
                          Text("Let's start learning!", style: TextStyle(color: AppTheme.secondaryText, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  // Gem/XP Count
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.diamond, color: AppTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Text("1,250", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.white)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Banner Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2848), AppTheme.primaryBlue], // Darker Blue to Bright Blue
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
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
                            "Test Your Knowledge!",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Take a quiz now.",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/quizUnlock'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue, // Bright Blue Button
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 4,
                            ),
                            child: const Text("Play Now", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    // Trophy Image Placeholder
                    Icon(Icons.emoji_events_rounded, color: Colors.white.withOpacity(0.9), size: 90),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Search Bar ---
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search subjects...",
                  // The styling is handled by the Theme in app_theme.dart
                  prefixIcon: const Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 30),

              // --- Subjects Section ---
              const Text("Subjects", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.white)),
              const SizedBox(height: 16),
              
              // Horizontal Scroll View for Subjects
              SizedBox(
                height: 120, // Fixed height for the horizontal list
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _subjectCard(context, "Math", Icons.calculate, Colors.orange),
                    _subjectCard(context, "Science", Icons.science, Colors.blue),
                    _subjectCard(context, "History", Icons.menu_book, Colors.green),
                    _subjectCard(context, "Art", Icons.palette, Colors.purple),
                    _subjectCard(context, "Comp", Icons.computer, Colors.cyan),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Recent Activity List ---
              const Text("Recent Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.white)),
              const SizedBox(height: 16),
              _activityItem("Algebra Basics", "80%", AppTheme.primaryBlue),
              _activityItem("World History", "95%", Colors.green),
              _activityItem("Physics Intro", "60%", Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectCard(BuildContext context, String name, IconData icon, Color iconColor) {
    return GestureDetector(
      onTap: () {
        // Navigate to Quiz List (placeholder for now)
        Navigator.pushNamed(context, '/quizQuestions');
      },
      child: Container(
        width: 100, // Fixed width for square-ish look
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.surface, // Dark Navy Surface
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.15), // Subtle colored circle
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              name, 
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w600, 
                color: AppTheme.white
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(String subject, String score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Subtle border
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
                Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.white)),
                const SizedBox(height: 4),
                Text("Quiz Result", style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText)),
              ],
            ),
          ),
          Text(score, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}