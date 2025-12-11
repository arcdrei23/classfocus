// lib/screens/student/dashboard/tabs/home_dashboard_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../theme/app_theme.dart';
import '../../../../services/auth_service.dart';
import '../../../../constants.dart';

class HomeDashboardTab extends StatelessWidget {
  const HomeDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;

        return Scaffold(
          backgroundColor: AppTheme.background, 
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fetch user name from Firestore
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseAuth.instance.currentUser != null
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots()
                        : null,
                    builder: (context, snapshot) {
                      String userName = "Loading...";
                      int xp = user?.xp ?? 0;
                      String? profileImageUrl = user?.profileImageUrl;
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        userName = "Loading...";
                      } else if (snapshot.hasData && snapshot.data!.exists) {
                        final data = snapshot.data!.data() as Map<String, dynamic>?;
                        final name = data?['name']?.toString();
                        userName = name != null && name.isNotEmpty 
                            ? name
                            : "User";
                      } else {
                        userName = user?.name ?? "Student";
                      }
                      
                      return _buildUserHeader(
                        userName,
                        xp,
                        profileImageUrl,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildBannerCard(context),
                  const SizedBox(height: 24),
                  _buildJoinQuizButton(context),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSubjectsSection(context),
                  const SizedBox(height: 24),
                  _buildAnnouncementsSection(),
                  const SizedBox(height: 24),
                  _buildRecentActivityList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(String userName, int xp, String? profileImageUrl) {
    final avatarUrl = profileImageUrl ?? kDefaultAvatarUrl;
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
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.surface,
                child: ClipOval(
                  child: Image.network(
                    // prefer user's profileImageUrl when available
                    avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.white);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back,",
                  style: TextStyle(fontSize: 14, color: AppTheme.secondaryText),
                ),
                Flexible(
                  child: Text(
                    userName,
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
            children: [
              const Icon(Icons.star_rounded, color: Colors.orange, size: 22),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                "${_formatNumber(xp)} XP", 
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- (The rest of your code remains untouched) ---

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
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Test Your Knowledge\nwith Subject Quizzes",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: 8),
          Icon(Icons.emoji_events_rounded, color: Colors.white.withOpacity(0.9), size: 70),
        ],
      ),
    );
  }

  Widget _buildJoinQuizButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showJoinQuizDialog(context),
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Join Quiz with Code'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _showJoinQuizDialog(BuildContext context) async {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Quiz'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Enter Quiz Code',
            hintText: 'e.g., XY92B',
          ),
          textCapitalization: TextCapitalization.characters,
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim().toUpperCase();
              if (code.isEmpty) return;
              
              Navigator.pop(context);
              
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                // Query Firestore for quiz with this access code
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('quizzes')
                    .where('accessCode', isEqualTo: code)
                    .limit(1)
                    .get();
                
                if (!context.mounted) return;
                Navigator.pop(context); // Close loading
                
                if (querySnapshot.docs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiz code not found')),
                  );
                  return;
                }
                
                final quizDoc = querySnapshot.docs.first;
                final quizData = quizDoc.data();
                
                // Navigate to quiz
                Navigator.pushNamed(
                  context,
                  '/quizQuestions',
                  arguments: quizData,
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context); // Close loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error joining quiz: $e')),
                );
              }
            },
            child: const Text('Join'),
          ),
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
    final subjects = [
      {"name": "Data Structures", "icon": Icons.storage, "color": Colors.pink},
      {"name": "Networking", "icon": Icons.router, "color": Colors.lightBlue},
      {"name": "Database Systems", "icon": Icons.dns, "color": Colors.purple},
      {"name": "Web Dev", "icon": Icons.code, "color": Colors.cyan},
      {"name": "HCI", "icon": Icons.people, "color": Colors.orange},
      {"name": "OS", "icon": Icons.memory, "color": Colors.green},
      {"name": "OOP", "icon": Icons.view_module, "color": Colors.yellow},
      {"name": "Capstone", "icon": Icons.rocket_launch, "color": Colors.deepPurple},
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
                Navigator.pushNamed(
                  context,
                  '/subjectDetail',
                  arguments: sub['name'] as String,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  Flexible(
                    child: Text(
                    sub['name'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.secondaryText),
                    textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

  String _formatNumber(int number) {
    final numberStr = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(numberStr[i]);
    }
    return buffer.toString();
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Completed just now",
                  style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(score, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  /// Build Announcements Section with real-time Firestore data
  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Announcements",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('announcements')
              .orderBy('timestamp', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "No announcements yet",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final announcement = snapshot.data!.docs[index];
                final data = announcement.data() as Map<String, dynamic>;
                final isUrgent = data['isUrgent'] ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUrgent ? Colors.red[50] : Colors.blue[50],
                    border: Border(
                      left: BorderSide(
                        color: isUrgent ? Colors.red : Colors.blue,
                        width: 4,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUrgent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "URGENT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['content'] ?? 'No content',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "By ${data['teacherName'] ?? 'Unknown'} • ${data['targetClass'] ?? 'All Classes'}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );

  }
}