// lib/models/lesson_model.dart

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String content; // could be HTML, text, markdown
  final String classId;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.classId,
  });
}
