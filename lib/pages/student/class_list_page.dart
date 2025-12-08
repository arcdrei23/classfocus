import 'package:flutter/material.dart';
import 'lessons_page.dart';

class ClassListPage extends StatelessWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {"id": "c1", "title": "Mathematics 6"},
      {"id": "c2", "title": "Science 6"},
      {"id": "c3", "title": "English 6"},
      {"id": "c4", "title": "Araling Panlipunan"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Classes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          var item = classes[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsPage(classId: item["id"]!),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.7),
                    Colors.deepPurple.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.class_, color: Colors.white, size: 40),
                  const SizedBox(width: 15),
                  Text(
                    item["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
