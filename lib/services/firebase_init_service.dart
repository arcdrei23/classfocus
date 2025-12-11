// lib/services/firebase_init_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class FirebaseInitService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize sample data for testing
  static Future<void> initializeSampleData() async {
    try {
      // Check if data already exists
      final quizzesSnapshot = await _firestore.collection('quizzes').limit(1).get();
      if (quizzesSnapshot.docs.isNotEmpty) {
        print('Sample data already exists');
        return;
      }

      // Create sample quiz with code
      final sampleQuiz = QuizModel(
        id: 'quiz_001',
        title: 'Data Structures Fundamentals',
        subject: 'Data Structures',
        accessCode: 'ABC123',
        createdBy: 'teacher@example.com',
        durationMinutes: 15,
        isPublished: true,
        questions: [
          Question(
            id: 'q1',
            questionText: 'What is the time complexity of binary search?',
            options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q2',
            questionText: 'Which data structure uses LIFO principle?',
            options: ['Queue', 'Stack', 'Tree', 'Graph'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q3',
            questionText: 'What is the maximum number of edges in a simple graph with 4 vertices?',
            options: ['6', '8', '12', '16'],
            correctAnswerIndex: 0,
          ),
          Question(
            id: 'q4',
            questionText: 'Which sorting algorithm is most stable?',
            options: ['Quick Sort', 'Merge Sort', 'Heap Sort', 'Selection Sort'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q5',
            questionText: 'What is the space complexity of merge sort?',
            options: ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q6',
            questionText: 'In a binary tree, what is the maximum number of nodes at level k?',
            options: ['k', 'k²', '2^k', '2^(k-1)'],
            correctAnswerIndex: 2,
          ),
          Question(
            id: 'q7',
            questionText: 'Which of the following is NOT a linear data structure?',
            options: ['Array', 'Linked List', 'Tree', 'Stack'],
            correctAnswerIndex: 2,
          ),
          Question(
            id: 'q8',
            questionText: 'What is the time complexity of insertion in a hash table on average?',
            options: ['O(n)', 'O(log n)', 'O(1)', 'O(n²)'],
            correctAnswerIndex: 2,
          ),
          Question(
            id: 'q9',
            questionText: 'Which traversal technique uses a queue?',
            options: ['DFS', 'BFS', 'In-order', 'Pre-order'],
            correctAnswerIndex: 1,
          ),
          Question(
            id: 'q10',
            questionText: 'What is the worst-case time complexity of quicksort?',
            options: ['O(n log n)', 'O(n)', 'O(n²)', 'O(log n)'],
            correctAnswerIndex: 2,
          ),
        ],
        studentParticipants: ['1@gmail.com'],
        leaderboardData: [
          LeaderboardEntry(
            studentEmail: '1@gmail.com',
            studentName: 'Student One',
            score: 9,
            totalQuestions: 10,
            completedAt: DateTime.now(),
          ),
        ],
      );

      // Save to Firestore
      await _firestore
          .collection('quizzes')
          .doc(sampleQuiz.id)
          .set(sampleQuiz.toMap());

      print('Sample quiz created successfully with code: ABC123');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }

  /// Create a new quiz
  static Future<String> createQuiz(QuizModel quiz) async {
    try {
      final docRef = _firestore.collection('quizzes').doc(quiz.id);
      await docRef.set(quiz.toMap());
      return quiz.id;
    } catch (e) {
      print('Error creating quiz: $e');
      rethrow;
    }
  }

  /// Get quiz by access code
  static Future<QuizModel?> getQuizByCode(String accessCode) async {
    try {
      final querySnapshot = await _firestore
          .collection('quizzes')
          .where('accessCode', isEqualTo: accessCode.toUpperCase())
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return QuizModel.fromMap(querySnapshot.docs.first.data());
    } catch (e) {
      print('Error fetching quiz: $e');
      return null;
    }
  }

  /// Get all quizzes for a subject
  static Future<List<QuizModel>> getQuizzesBySubject(String subject) async {
    try {
      final querySnapshot = await _firestore
          .collection('quizzes')
          .where('subject', isEqualTo: subject)
          .where('isPublished', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  /// Update quiz leaderboard
  static Future<void> addToLeaderboard(
    String quizId,
    LeaderboardEntry entry,
  ) async {
    try {
      await _firestore
          .collection('quizzes')
          .doc(quizId)
          .update({
        'leaderboardData': FieldValue.arrayUnion([entry.toMap()]),
      });
    } catch (e) {
      print('Error updating leaderboard: $e');
    }
  }

  /// Get leaderboard for a quiz
  static Future<List<LeaderboardEntry>> getLeaderboard(String quizId) async {
    try {
      final docSnapshot =
          await _firestore.collection('quizzes').doc(quizId).get();

      if (!docSnapshot.exists) {
        return [];
      }

      final data = docSnapshot.data();
      final leaderboardData = data?['leaderboardData'] as List? ?? [];

      return leaderboardData
          .map((e) => LeaderboardEntry.fromMap(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }
}
