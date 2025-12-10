// lib/models/user_model.dart

class ActivityItem {
  final String subjectName;
  final String topic;
  final String timeAgo;
  final String score;

  ActivityItem({
    required this.subjectName,
    required this.topic,
    required this.timeAgo,
    required this.score,
  });
}

class UserModel {
  final String id;
  final String name;
  final String email;      // <--- 1. Added Email
  final String studentId;
  final int xp;
  final int streak;        // <--- 2. Added Streak
  final String profileImageUrl;
  final List<ActivityItem> recentActivities;

  UserModel({
    required this.id,
    required this.name,
    required this.email,     // <--- Added to constructor
    required this.studentId,
    required this.xp,
    required this.streak,    // <--- Added to constructor
    required this.profileImageUrl,
    required this.recentActivities,
  });
}