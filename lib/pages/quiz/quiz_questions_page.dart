import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../score/score_summary_page.dart';

class QuizQuestionsPage extends StatefulWidget {
  const QuizQuestionsPage({super.key});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  int currentIndex = 0;
  int score = 0;
  int correctCount = 0;
  int wrongCount = 0;
  List<int?> selectedAnswers = [];

  // Sample questions - replace with actual quiz data
  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: "What is 8 × 7?",
      answers: ["54", "56", "48", "49"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "The Earth revolves around the ___",
      answers: ["Moon", "Sun", "Mars", "Clouds"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which is a noun?",
      answers: ["Run", "Blue", "Happiness", "Quickly"],
      correctIndex: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
        if (selectedAnswers[i] == questions[i].correctIndex) {
          score++;
          correctCount++;
        } else {
          wrongCount++;
        }
      }

      // Navigate to score summary page
      Navigator.push(
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
    final currentQuestion = questions[currentIndex];
    final isLastQuestion = currentIndex == questions.length - 1;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Question ${currentIndex + 1} of ${questions.length}"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              minHeight: 8,
            ),

            const SizedBox(height: 30),

            // Question text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                currentQuestion.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.answers.length,
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
                          color: isSelected ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Colors.deepPurple.withOpacity(0.3)
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
                                    : Colors.grey[300],
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.deepPurple
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                currentQuestion.answers[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
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
                backgroundColor: Colors.deepPurple,
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
