// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  
  // Mock users database (for backward compatibility)
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@student.school.edu',
      studentId: 'ID 12345',
      xp: 850,
      streak: 7,
      profileImageUrl: kDefaultAvatarUrl,
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
      email: 'student.a@school.edu',
      studentId: 'ID 67890',
      xp: 1200,
      streak: 5,
      profileImageUrl: kDefaultAvatarUrl,
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
      email: 'student.b@school.edu',
      studentId: 'ID 11111',
      xp: 450,
      streak: 3,
      profileImageUrl: kDefaultAvatarUrl,
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

  // Firebase Auth current user
  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  // Sign up method - Creates Firebase Auth user and saves to Firestore
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role, // 'student' or 'teacher'
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Login function - accepts username (for simplicity, we'll match by name or studentId)
  // This is kept for backward compatibility with mock login
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

