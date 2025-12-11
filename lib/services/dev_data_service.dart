// lib/services/dev_data_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

/// Service to initialize seed data for development/testing purposes.
/// Creates sample user accounts and quizzes for testing the app.
class DevDataService {
  static const String studentEmail = '1@gmail.com';
  static const String studentPassword = 'password123'; // Use secure password in production
  static const String teacherEmail = '2@gmail.com';
  static const String teacherPassword = 'password123'; // Use secure password in production

  /// Initialize dev data: creates student and teacher accounts with sample quizzes
  static Future<void> initializeDevData() async {
    try {
      // Step 1: Create Student Account (1@gmail.com)
      await _createStudentIfNotExists();

      // Step 2: Create Teacher Account (2@gmail.com)
      await _createTeacherIfNotExists();

      // Step 3: Create Sample Subject for Teacher
      await _createSampleSubjectIfNotExists();

      // Step 4: Create Sample Quizzes for the Teacher
      await _createSampleQuizzesIfNotExists();

      print('[DevDataService] Dev data initialized successfully');
    } catch (e) {
      print('[DevDataService] Error initializing dev data: $e');
    }
  }

  /// Creates student account if it doesn't exist
  static Future<void> _createStudentIfNotExists() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Check if user exists in Firestore
    final studentDocRef = firestore.collection('users').doc(studentEmail.replaceAll('@', '_').replaceAll('.', '_'));
    final studentDoc = await studentDocRef.get();

    if (!studentDoc.exists) {
      try {
        // Create auth account
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: studentEmail,
          password: studentPassword,
        );

        // Create Firestore document
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': studentEmail,
          'name': 'Student One',
          'role': 'student',
          'createdAt': FieldValue.serverTimestamp(),
          'profileImageUrl': 'https://i.pravatar.cc/300?u=$studentEmail',
          'joinedQuizzes': [],
        });

        print('[DevDataService] Student account created: $studentEmail');
      } catch (e) {
        print('[DevDataService] Error creating student account: $e');
      }
    } else {
      print('[DevDataService] Student account already exists: $studentEmail');
    }
  }

  /// Creates teacher account if it doesn't exist
  static Future<void> _createTeacherIfNotExists() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Check if user exists in Firestore
    final teacherDocRef = firestore.collection('users').doc(teacherEmail.replaceAll('@', '_').replaceAll('.', '_'));
    final teacherDoc = await teacherDocRef.get();

    if (!teacherDoc.exists) {
      try {
        // Create auth account
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: teacherEmail,
          password: teacherPassword,
        );

        // Create Firestore document
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': teacherEmail,
          'name': 'Teacher One',
          'role': 'teacher',
          'createdAt': FieldValue.serverTimestamp(),
          'profileImageUrl': 'https://i.pravatar.cc/300?u=$teacherEmail',
          'subjects': [],
        });

        print('[DevDataService] Teacher account created: $teacherEmail');
      } catch (e) {
        print('[DevDataService] Error creating teacher account: $e');
      }
    } else {
      print('[DevDataService] Teacher account already exists: $teacherEmail');
    }
  }

  /// Creates a sample subject for the teacher
  static Future<void> _createSampleSubjectIfNotExists() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Check if subject already exists
      final subjectsQuery = await firestore
          .collection('subjects')
          .where('name', isEqualTo: 'Data Structures')
          .where('createdBy', isEqualTo: teacherEmail)
          .limit(1)
          .get();

      if (subjectsQuery.docs.isEmpty) {
        await firestore.collection('subjects').add({
          'name': 'Data Structures',
          'description': 'Fundamentals of Data Structures and Algorithms',
          'createdBy': teacherEmail,
          'createdAt': FieldValue.serverTimestamp(),
          'icon': 'books',
        });

        print('[DevDataService] Sample subject created: Data Structures');
      } else {
        print('[DevDataService] Sample subject already exists');
      }
    } catch (e) {
      print('[DevDataService] Error creating sample subject: $e');
    }
  }

  /// Creates sample quizzes for the teacher
  static Future<void> _createSampleQuizzesIfNotExists() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Check if sample quiz already exists
      final quizzesQuery = await firestore
          .collection('quizzes')
          .where('title', isEqualTo: 'Data Structures Fundamentals')
          .where('createdBy', isEqualTo: teacherEmail)
          .limit(1)
          .get();

      if (quizzesQuery.docs.isEmpty) {
        // Create sample questions
        final sampleQuestions = [
          Question(
            id: '1',
            questionText: 'What is the time complexity of binary search?',
            options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: '2',
            questionText: 'Which data structure uses LIFO principle?',
            options: ['Queue', 'Stack', 'Tree', 'Graph'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: '3',
            questionText: 'What is the worst-case time complexity of Quick Sort?',
            options: ['O(n log n)', 'O(n²)', 'O(n)', 'O(log n)'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: '4',
            questionText: 'Which of the following is NOT a linear data structure?',
            options: ['Array', 'Linked List', 'Stack', 'Tree'],
            correctAnswerIndex: 3,
          ),
          Question(
            id: '5',
            questionText: 'What is the space complexity of merge sort?',
            options: ['O(1)', 'O(n)', 'O(n log n)', 'O(n²)'],
            correctAnswerIndex: 1,
          ),
        ];

        // Create quiz model
        final quiz = QuizModel(
          id: 'quiz_sample_001',
          title: 'Data Structures Fundamentals',
          subject: 'Data Structures',
          questions: sampleQuestions,
          isPublished: true,
          durationMinutes: 10,
          accessCode: 'ABC123',
          createdBy: teacherEmail,
          studentParticipants: [studentEmail],
          leaderboardData: [],
          createdAt: DateTime.now(),
        );

        // Save to Firestore
        await firestore.collection('quizzes').doc(quiz.id).set(quiz.toMap());

        print('[DevDataService] Sample quiz created: ${quiz.title}');
        print('[DevDataService] Access code: ${quiz.accessCode}');
      } else {
        print('[DevDataService] Sample quiz already exists');
      }
    } catch (e) {
      print('[DevDataService] Error creating sample quizzes: $e');
    }
  }
}
