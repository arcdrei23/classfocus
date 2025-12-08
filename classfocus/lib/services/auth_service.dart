// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  
  // Mock users database
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      name: 'John Doe',
      studentId: 'ID 12345',
      xp: 850,
      profileImageUrl: 'assets/images/logo.png',
      recentActivities: [
        ActivityItem(
          subjectName: 'Networking',
          topic: 'Intro to Routing',
          timeAgo: '25m ago',
          score: '85/100',
        ),
        ActivityItem(
          subjectName: 'Data Structures',
          topic: 'Linked Lists',
          timeAgo: '1h ago',
          score: '92/100',
        ),
      ],
    ),
    UserModel(
      id: '2',
      name: 'Student A',
      studentId: 'ID 67890',
      xp: 1200,
      profileImageUrl: 'assets/images/logo.png',
      recentActivities: [
        ActivityItem(
          subjectName: 'Networking',
          topic: 'Advanced Routing',
          timeAgo: '2h ago',
          score: '95/100',
        ),
        ActivityItem(
          subjectName: 'Networking',
          topic: 'Network Security',
          timeAgo: '3h ago',
          score: '88/100',
        ),
      ],
    ),
    UserModel(
      id: '3',
      name: 'Student B',
      studentId: 'ID 11111',
      xp: 450,
      profileImageUrl: 'assets/images/logo.png',
      recentActivities: [
        ActivityItem(
          subjectName: 'Database Systems',
          topic: 'SQL Basics',
          timeAgo: '30m ago',
          score: '78/100',
        ),
        ActivityItem(
          subjectName: 'Database Systems',
          topic: 'Normalization',
          timeAgo: '2h ago',
          score: '82/100',
        ),
      ],
    ),
  ];

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Login function - accepts username (for simplicity, we'll match by name or studentId)
  bool login(String username) {
    // Try to find user by name or studentId
    final user = _mockUsers.firstWhere(
      (user) => user.name.toLowerCase().contains(username.toLowerCase()) ||
                user.studentId.toLowerCase().contains(username.toLowerCase()),
      orElse: () => _mockUsers[0], // Default to first user if not found
    );

    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

