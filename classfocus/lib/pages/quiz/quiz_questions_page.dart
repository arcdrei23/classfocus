import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../../theme/app_theme.dart';
import '../score/score_summary_page.dart';

class QuizQuestionsPage extends StatefulWidget {
  final QuizModel? quiz;

  const QuizQuestionsPage({super.key, this.quiz});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  int currentIndex = 0;
  int score = 0;
  int correctCount = 0;
  int wrongCount = 0;
  List<int?> selectedAnswers = [];

  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    // Get quiz from arguments if not provided directly
    final quiz = widget.quiz ?? 
        (ModalRoute.of(context)?.settings.arguments as QuizModel?);
    
    if (quiz != null) {
      questions = quiz.questions;
    } else {
      // Fallback to sample questions if no quiz provided
      questions = [
        Question(
          id: '1',
          questionText: "What is 8 × 7?",
          options: ["54", "56", "48", "49"],
          correctAnswerIndex: 1,
        ),
        Question(
          id: '2',
          questionText: "The Earth revolves around the ___",
          options: ["Moon", "Sun", "Mars", "Clouds"],
          correctAnswerIndex: 1,
        ),
        Question(
          id: '3',
          questionText: "Which is a noun?",
          options: ["Run", "Blue", "Happiness", "Quickly"],
          correctAnswerIndex: 2,
        ),
      ];
    }
    selectedAnswers = List.filled(questions.length, null);
  }

  void handleAnswer(int answerIndex) {
    setState(() {
      selectedAnswers[currentIndex] = answerIndex;
    });
  }

  void handleNextOrSubmit() {
    if (currentIndex == questions.length - 1) {
      // Calculate final score
      score = 0;
      correctCount = 0;
      wrongCount = 0;

      for (int i = 0; i < questions.length; i++) {
        if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
          score++;
          correctCount++;
        } else {
          wrongCount++;
        }
      }

      // Navigate to score summary page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScoreSummaryPage(
            score: score,
            total: questions.length,
            correct: correctCount,
            wrong: wrongCount,
          ),
        ),
      );
    } else {
      // Move to next question
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz"),
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text("No questions available"),
        ),
      );
    }

    final currentQuestion = questions[currentIndex];
    final isLastQuestion = currentIndex == questions.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text("Question ${currentIndex + 1} of ${questions.length}"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                backgroundColor: AppTheme.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 30),

            // Question text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                currentQuestion.questionText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswers[currentIndex] == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => handleAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.secondaryText.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppTheme.primaryBlue.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.secondaryText,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppTheme.primaryBlue,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                currentQuestion.options[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Next/Submit button
            ElevatedButton(
              onPressed: selectedAnswers[currentIndex] != null
                  ? handleNextOrSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                isLastQuestion ? "Submit" : "Next",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
