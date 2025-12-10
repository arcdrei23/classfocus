// lib/services/quiz_provider.dart
import 'package:flutter/foundation.dart';
import '../models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  static final QuizProvider _instance = QuizProvider._internal();
  factory QuizProvider() => _instance;
  QuizProvider._internal() {
    // Initialize with default quizzes so students have content to see
    _initializeDefaultQuizzes();
  }

  final List<QuizModel> _allQuizzes = [];

  void _initializeDefaultQuizzes() {
    // Add default quiz for Data Structures
    _allQuizzes.add(QuizModel(
      id: 'default_ds_1',
      title: 'Linked Lists Basics',
      subject: 'Data Structures',
      isPublished: true,
      durationMinutes: 7,
      questions: [
        Question(
          id: 'q1',
          questionText: 'What is a linked list?',
          options: [
            'A linear data structure',
            'A tree data structure',
            'A graph data structure',
            'A hash table',
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          id: 'q2',
          questionText: 'What is the time complexity of inserting at the beginning of a linked list?',
          options: ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'],
          correctAnswerIndex: 0,
        ),
        Question(
          id: 'q3',
          questionText: 'Which of the following is a disadvantage of linked lists?',
          options: [
            'Random access is not possible',
            'Extra memory space for pointers',
            'Both A and B',
            'None of the above',
          ],
          correctAnswerIndex: 2,
        ),
      ],
    ));

    // Add default quiz for OOP
    _allQuizzes.add(QuizModel(
      id: 'default_oop_1',
      title: 'OOP Fundamentals',
      subject: 'OOP',
      isPublished: true,
      durationMinutes: 10,
      questions: [
        Question(
          id: 'q4',
          questionText: 'What are the four pillars of OOP?',
          options: [
            'Encapsulation, Inheritance, Polymorphism, Abstraction',
            'Class, Object, Method, Variable',
            'Public, Private, Protected, Static',
            'None of the above',
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          id: 'q5',
          questionText: 'What is encapsulation?',
          options: [
            'Binding data and methods together',
            'Creating multiple objects',
            'Inheriting from parent class',
            'Overriding methods',
          ],
          correctAnswerIndex: 0,
        ),
      ],
    ));

    // Add default quiz for Networking
    _allQuizzes.add(QuizModel(
      id: 'default_net_1',
      title: 'Intro to Routing',
      subject: 'Networking',
      isPublished: true,
      durationMinutes: 8,
      questions: [
        Question(
          id: 'q6',
          questionText: 'What is the purpose of a router?',
          options: [
            'To connect different networks',
            'To filter network traffic',
            'To provide wireless access',
            'All of the above',
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          id: 'q7',
          questionText: 'Which protocol is used for routing?',
          options: ['TCP', 'UDP', 'IP', 'HTTP'],
          correctAnswerIndex: 2,
        ),
      ],
    ));

    // Add default quiz for Database Systems
    _allQuizzes.add(QuizModel(
      id: 'default_db_1',
      title: 'SQL Basics',
      subject: 'Database Systems',
      isPublished: true,
      durationMinutes: 7,
      questions: [
        Question(
          id: 'q8',
          questionText: 'What does SQL stand for?',
          options: [
            'Structured Query Language',
            'Simple Query Language',
            'Standard Query Language',
            'System Query Language',
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          id: 'q9',
          questionText: 'Which SQL command is used to retrieve data?',
          options: ['SELECT', 'GET', 'FETCH', 'RETRIEVE'],
          correctAnswerIndex: 0,
        ),
      ],
    ));
  }

  List<QuizModel> get allQuizzes => List.unmodifiable(_allQuizzes);

  // Add quiz (called by Teacher)
  void addQuiz(QuizModel quiz) {
    _allQuizzes.add(quiz);
    notifyListeners();
  }

  // Get quizzes by subject (called by Student)
  List<QuizModel> getQuizzesBySubject(String subject) {
    return _allQuizzes
        .where((quiz) => quiz.subject == subject && quiz.isPublished)
        .toList();
  }

  // Get quiz by ID
  QuizModel? getQuizById(String id) {
    try {
      return _allQuizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  // Remove quiz (optional, for teacher to delete)
  void removeQuiz(String id) {
    _allQuizzes.removeWhere((quiz) => quiz.id == id);
    notifyListeners();
  }
}

