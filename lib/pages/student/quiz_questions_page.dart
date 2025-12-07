import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../score/score_summary_page.dart';

class QuizQuestionsPage extends StatefulWidget {
  const QuizQuestionsPage({super.key});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  int currentIndex = 0;

  List<int?> selectedAnswers = [];

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
    pageController = PageController();
    selectedAnswers = List.filled(questions.length, null);
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  void submitQuiz() {
    int score = 0;
    int correctCount = 0;
    int wrongCount = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctIndex) {
        score++;
        correctCount++;
      } else {
        wrongCount++;
      }
    }

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
  }

  Widget buildOption({
    required String text,
    required int optionIndex,
    required int questionIndex,
  }) {
    bool isSelected = selectedAnswers[questionIndex] == optionIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswers[questionIndex] = optionIndex;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: isSelected
                ? [Colors.purpleAccent, Colors.blueAccent]
                : [Colors.white10, Colors.white12],
          ),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.white30,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget buildQuestionCard(QuizQuestion question, int index) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            "Question ${index + 1}",
            style: const TextStyle(
                fontSize: 22,
                color: Colors.white70,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            question.question,
            style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          // Options
          ...List.generate(
            question.answers.length,
            (optionIndex) => buildOption(
              text: question.answers[optionIndex],
              optionIndex: optionIndex,
              questionIndex: index,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Question ${currentIndex + 1} of ${questions.length}",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          // Questions PageView
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: questions.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => currentIndex = i),
              itemBuilder: (context, index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: buildQuestionCard(questions[index], index),
                );
              },
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous
                if (currentIndex > 0)
                  ElevatedButton(
                    onPressed: previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("Previous",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                else
                  const SizedBox(width: 110),

                // Next or Submit
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex == questions.length - 1) {
                      submitQuiz();
                    } else {
                      nextQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1
                        ? "Submit"
                        : "Next",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
