// lib/models/quiz_model.dart

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

class QuizModel {
  final String id;
  final String title;
  final List<QuizQuestion> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
  });
}
