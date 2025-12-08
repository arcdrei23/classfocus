import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import 'lesson_viewer_page.dart';

class LessonsPage extends StatelessWidget {
  final String classId;

  const LessonsPage({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final List<LessonModel> lessons = [
      LessonModel(
        id: "l1",
        title: "Introduction to Fractions",
        description: "Learn the basics of fractions.",
        content: "This is the FULL lesson content about fractions...",
        classId: "c1",
      ),
      LessonModel(
        id: "l2",
        title: "Earth, Sun & Moon",
        description: "How heavenly bodies interact.",
        content: "This is the FULL science lesson about Earth-Sun-Moon...",
        classId: "c2",
      ),
      LessonModel(
        id: "l3",
        title: "Parts of Speech",
        description: "Learn nouns, verbs, adjectives.",
        content: "Here is the English lesson...",
        classId: "c3",
      ),
    ];

    final filteredLessons =
        lessons.where((l) => l.classId == classId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lessons"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: filteredLessons.length,
        itemBuilder: (context, index) {
          final lesson = filteredLessons[index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.7),
                  Colors.blueAccent.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2),
              ],
            ),
            child: ListTile(
              title: Text(
                lesson.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                lesson.description,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonViewerPage(lesson: lesson),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
