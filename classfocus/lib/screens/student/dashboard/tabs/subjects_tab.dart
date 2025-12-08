// lib/screens/student/dashboard/tabs/subjects_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_theme.dart';
import '../../../../services/quiz_provider.dart';

class SubjectsTab extends StatelessWidget {
  const SubjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Subjects",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<QuizProvider>(
                  builder: (context, quizProvider, child) {
                    // IT Subjects with quiz availability
                    final subjects = [
                      {
                        "name": "Data Structures",
                        "icon": Icons.storage,
                        "color": Colors.pink,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('Data Structures').isNotEmpty,
                      },
                      {
                        "name": "Networking",
                        "icon": Icons.router,
                        "color": Colors.lightBlue,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('Networking').isNotEmpty,
                      },
                      {
                        "name": "Database Systems",
                        "icon": Icons.dns,
                        "color": Colors.purple,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('Database Systems').isNotEmpty,
                      },
                      {
                        "name": "Web Dev",
                        "icon": Icons.code,
                        "color": Colors.cyan,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('Web Dev').isNotEmpty,
                      },
                      {
                        "name": "HCI",
                        "icon": Icons.people,
                        "color": Colors.orange,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('HCI').isNotEmpty,
                      },
                      {
                        "name": "OS",
                        "icon": Icons.memory,
                        "color": Colors.green,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('OS').isNotEmpty,
                      },
                      {
                        "name": "OOP",
                        "icon": Icons.view_module,
                        "color": Colors.yellow,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('OOP').isNotEmpty,
                      },
                      {
                        "name": "Capstone",
                        "icon": Icons.rocket_launch,
                        "color": Colors.deepPurple,
                        "hasQuizzes": quizProvider.getQuizzesBySubject('Capstone').isNotEmpty,
                      },
                    ];

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        final sub = subjects[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/subjectDetail',
                              arguments: sub['name'] as String,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: (sub['color'] as Color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    sub['icon'] as IconData,
                                    color: sub['color'] as Color,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  sub['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (sub['hasQuizzes'] as bool)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${quizProvider.getQuizzesBySubject(sub['name'] as String).length} Quiz${quizProvider.getQuizzesBySubject(sub['name'] as String).length > 1 ? 'zes' : ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                else
                                  const Text(
                                    'No quizzes',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.secondaryText,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

