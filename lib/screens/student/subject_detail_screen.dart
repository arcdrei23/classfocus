// lib/screens/student/subject_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/quiz_provider.dart';
import '../../models/quiz_model.dart';

class SubjectDetailScreen extends StatelessWidget {
  final String subjectName;

  const SubjectDetailScreen({
    super.key,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          final quizzes = quizProvider.getQuizzesBySubject(subjectName);

          return CustomScrollView(
            slivers: [
              // App Bar with back button
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  subjectName,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 200,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        AppTheme.primaryBlue.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Glowing particles effect
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.3,
                          child: CustomPaint(
                            painter: ParticlePainter(),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          subjectName,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Progress Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.75, // 75/100
                          minHeight: 8,
                          backgroundColor: AppTheme.surface,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '75/100',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Quiz List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quizzes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (quizzes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'No quizzes available yet',
                              style: TextStyle(
                                color: AppTheme.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        ...quizzes.map((quiz) => _buildQuizCard(context, quiz)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizModel quiz) {
    IconData icon;
    switch (quiz.subject) {
      case 'Data Structures':
        icon = Icons.view_module;
        break;
      case 'Networking':
        icon = Icons.router;
        break;
      case 'Database Systems':
        icon = Icons.dns;
        break;
      default:
        icon = Icons.quiz;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ),
        title: Text(
          quiz.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${quiz.questions.length} questions • ${quiz.durationMinutes} minutes',
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.secondaryText,
          size: 16,
        ),
        onTap: () {
          // Navigate to quiz start screen
          Navigator.pushNamed(
            context,
            '/quizStart',
            arguments: quiz,
          );
        },
      ),
    );
  }
}

// Simple particle painter for glowing effect
class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw some simple circles as particles
    for (int i = 0; i < 10; i++) {
      final x = (i * 50.0) % size.width;
      final y = (i * 30.0) % size.height;
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

