// lib/services/seed_data_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataService {
  static const String studentEmail = '1@gmail.com';
  static const String studentPassword = 'password123';
  static const String teacherEmail = '2@gmail.com';
  static const String teacherPassword = 'password123';

  /// Initialize test database with sample data
  static Future<void> seedTestDatabase() async {
    try {
      print('[SeedDataService] Starting seed data initialization...');

      // Create Student User
      await _createStudentUser();

      // Create Teacher User
      await _createTeacherUser();

      // Create Sample Subject
      await _createSampleSubject();

      // Create Sample Lesson
      await _createSampleLesson();

      // Create Sample Quiz History
      await _createSampleQuizHistory();

      print('[SeedDataService] Seed data initialization completed successfully!');
    } catch (e) {
      print('[SeedDataService] Error during seed initialization: $e');
    }
  }

  /// Create student user if doesn't exist
  static Future<void> _createStudentUser() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      // Check if user already exists
      final studentQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: studentEmail)
          .limit(1)
          .get();

      if (studentQuery.docs.isNotEmpty) {
        print('[SeedDataService] Student user already exists: $studentEmail');
        return;
      }

      // Create Firebase Auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: studentEmail,
        password: studentPassword,
      );

      final userId = userCredential.user!.uid;

      // Save to Firestore
      await firestore.collection('users').doc(userId).set({
        'uid': userId,
        'email': studentEmail,
        'name': 'Student One',
        'role': 'student',
        'xp': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': 'https://i.pravatar.cc/300?u=$studentEmail',
      });

      print('[SeedDataService] Student user created: $studentEmail');
    } catch (e) {
      print('[SeedDataService] Error creating student user: $e');
    }
  }

  /// Create teacher user if doesn't exist
  static Future<void> _createTeacherUser() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    try {
      // Check if user already exists
      final teacherQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: teacherEmail)
          .limit(1)
          .get();

      if (teacherQuery.docs.isNotEmpty) {
        print('[SeedDataService] Teacher user already exists: $teacherEmail');
        return;
      }

      // Create Firebase Auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: teacherEmail,
        password: teacherPassword,
      );

      final userId = userCredential.user!.uid;

      // Save to Firestore
      await firestore.collection('users').doc(userId).set({
        'uid': userId,
        'email': teacherEmail,
        'name': 'Teacher Two',
        'role': 'teacher',
        'xp': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': 'https://i.pravatar.cc/300?u=$teacherEmail',
      });

      print('[SeedDataService] Teacher user created: $teacherEmail');
    } catch (e) {
      print('[SeedDataService] Error creating teacher user: $e');
    }
  }

  /// Create sample subject
  static Future<void> _createSampleSubject() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Check if subject already exists
      final subjectQuery = await firestore
          .collection('subjects')
          .where('name', isEqualTo: 'Data Structures')
          .limit(1)
          .get();

      if (subjectQuery.docs.isNotEmpty) {
        print('[SeedDataService] Subject already exists: Data Structures');
        return;
      }

      // Create subject
      await firestore.collection('subjects').add({
        'name': 'Data Structures',
        'description': 'Learn fundamental data structures and algorithms',
        'icon': 'book',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': teacherEmail,
      });

      print('[SeedDataService] Subject created: Data Structures');
    } catch (e) {
      print('[SeedDataService] Error creating subject: $e');
    }
  }

  /// Create sample lesson
  static Future<void> _createSampleLesson() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Get the subject first
      final subjectQuery = await firestore
          .collection('subjects')
          .where('name', isEqualTo: 'Data Structures')
          .limit(1)
          .get();

      if (subjectQuery.docs.isEmpty) {
        print('[SeedDataService] Subject not found for lesson creation');
        return;
      }

      final subjectId = subjectQuery.docs.first.id;

      // Check if lesson already exists
      final lessonQuery = await firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('lessons')
          .where('title', isEqualTo: 'Introduction to Arrays')
          .limit(1)
          .get();

      if (lessonQuery.docs.isNotEmpty) {
        print('[SeedDataService] Lesson already exists: Introduction to Arrays');
        return;
      }

      // Create lesson
      await firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('lessons')
          .add({
        'title': 'Introduction to Arrays',
        'content': 'Arrays are the most basic and widely used data structures.',
        'duration': 30, // minutes
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': teacherEmail,
      });

      print('[SeedDataService] Lesson created: Introduction to Arrays');
    } catch (e) {
      print('[SeedDataService] Error creating lesson: $e');
    }
  }

  /// Create sample quiz history entry
  static Future<void> _createSampleQuizHistory() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Get student user
      final studentQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: studentEmail)
          .limit(1)
          .get();

      if (studentQuery.docs.isEmpty) {
        print('[SeedDataService] Student not found for quiz history');
        return;
      }

      final studentId = studentQuery.docs.first.id;

      // Check if quiz history already exists
      final quizHistoryQuery = await firestore
          .collection('users')
          .doc(studentId)
          .collection('quizHistory')
          .where('quizTitle', isEqualTo: 'Data Structures Basics Quiz')
          .limit(1)
          .get();

      if (quizHistoryQuery.docs.isNotEmpty) {
        print('[SeedDataService] Quiz history already exists');
        return;
      }

      // Create quiz history entry
      await firestore
          .collection('users')
          .doc(studentId)
          .collection('quizHistory')
          .add({
        'quizTitle': 'Data Structures Basics Quiz',
        'subject': 'Data Structures',
        'score': 85,
        'totalQuestions': 10,
        'duration': 15, // minutes
        'completedAt': FieldValue.serverTimestamp(),
        'passingScore': 60,
        'isPassed': true,
      });

      print('[SeedDataService] Quiz history created');
    } catch (e) {
      print('[SeedDataService] Error creating quiz history: $e');
    }
  }
}
