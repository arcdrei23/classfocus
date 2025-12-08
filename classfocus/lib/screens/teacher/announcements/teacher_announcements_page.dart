// lib/screens/teacher/announcements/teacher_announcements_page.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'create_announcement_screen.dart';

class TeacherAnnouncementsPage extends StatelessWidget {
  const TeacherAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock announcements - will be replaced with Firebase data
    final announcements = [
      {
        'id': '1',
        'title': 'Data Structures Quiz Tomorrow',
        'content': 'Your data team what tell doe, find andl seach ol-al you unit to reorrs a mint!',
        'class': 'All Classes',
        'timestamp': '2h ago',
        'isUrgent': false,
      },
      {
        'id': '2',
        'title': 'Linked Lists Basics Completed',
        'content': 'Your quizs evmplietted the data will-dcn subject-as. Is or cenomar!',
        'class': 'Math 6',
        'timestamp': '5h ago',
        'isUrgent': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAnnouncementScreen(),
                ),
              );
            },
            tooltip: 'Create Announcement',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return _buildAnnouncementCard(context, announcement);
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, Map<String, dynamic> announcement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (announcement['isUrgent'] as bool)
              ? Colors.red.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: (announcement['isUrgent'] as bool) ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (announcement['isUrgent'] as bool)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (announcement['isUrgent'] as bool) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  announcement['class'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                announcement['timestamp'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            announcement['title'] as String,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            announcement['content'] as String,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
