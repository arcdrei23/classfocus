// lib/models/student_model.dart

class StudentModel {
  final String id;
  String name;
  String avatarUrl;
  int xp;
  int streak;
  int quizzesCompleted;
  int highestScore;

  StudentModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.xp = 0,
    this.streak = 0,
    this.quizzesCompleted = 0,
    this.highestScore = 0,
  });
}
