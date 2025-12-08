// lib/models/quiz_model.dart
class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizModel {
  final String id;
  final String title;
  final String subject; // Must match Student's subject names
  final List<Question> questions;
  final bool isPublished;
  final int durationMinutes; // e.g., 7 minutes

  QuizModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    this.isPublished = false,
    this.durationMinutes = 7,
  });
}
