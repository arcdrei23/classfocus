import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';

class LessonViewerPage extends StatelessWidget {
  final LessonModel lesson;

  const LessonViewerPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            lesson.content,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
