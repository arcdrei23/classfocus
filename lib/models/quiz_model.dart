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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }
}

class LeaderboardEntry {
  final String studentEmail;
  final String studentName;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  LeaderboardEntry({
    required this.studentEmail,
    required this.studentName,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentEmail': studentEmail,
      'studentName': studentName,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      studentEmail: map['studentEmail'] ?? '',
      studentName: map['studentName'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      completedAt: DateTime.parse(map['completedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class QuizModel {
  final String id;
  final String title;
  final String subject;
  final List<Question> questions;
  final bool isPublished;
  final int durationMinutes;
  final String accessCode;
  final String createdBy;
  final List<String> studentParticipants;
  final List<LeaderboardEntry> leaderboardData;
  final DateTime createdAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    this.isPublished = false,
    this.durationMinutes = 7,
    this.accessCode = '',
    this.createdBy = '',
    this.studentParticipants = const [],
    this.leaderboardData = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'questions': questions.map((q) => q.toMap()).toList(),
      'isPublished': isPublished,
      'durationMinutes': durationMinutes,
      'accessCode': accessCode,
      'createdBy': createdBy,
      'studentParticipants': studentParticipants,
      'leaderboardData': leaderboardData.map((l) => l.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      questions: (map['questions'] as List?)
          ?.map((q) => Question.fromMap(q as Map<String, dynamic>))
          .toList() ?? [],
      isPublished: map['isPublished'] ?? false,
      durationMinutes: map['durationMinutes'] ?? 7,
      accessCode: map['accessCode'] ?? '',
      createdBy: map['createdBy'] ?? '',
      studentParticipants: List<String>.from(map['studentParticipants'] ?? []),
      leaderboardData: (map['leaderboardData'] as List?)
          ?.map((l) => LeaderboardEntry.fromMap(l as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
    );
  }
}
