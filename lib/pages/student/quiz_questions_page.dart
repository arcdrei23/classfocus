// lib/pages/student/quiz_questions_page.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../score/score_summary_page.dart';

class QuizQuestionsPage extends StatefulWidget {
  const QuizQuestionsPage({super.key});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  int currentIndex = 0;
  int? selectedOption;
  
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is 12 × 12?",
      "options": ["124", "144", "134", "148"],
      "answer": 1
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Venus", "Mars", "Jupiter"],
      "answer": 2
    },
    {
      "question": "What is the capital of the Philippines?",
      "options": ["Cebu", "Davao", "Manila", "Quezon City"],
      "answer": 2
    },
  ];

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      // Navigate to results
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (_) => ScoreSummaryPage(
            score: 29, // Example score
            total: 30, 
            correct: 29, 
            wrong: 1
          )
        )
      );
    }
  }

  void _prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        selectedOption = null; // Ideally, save selected state per question
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Math – 30 Questions", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "${currentIndex + 1}/${questions.length}",
                style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                backgroundColor: Colors.grey[200],
                color: AppTheme.primaryBlue,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 40),
            
            // Question
            Text(
              "Question ${currentIndex + 1}",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              q['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 40),

            // Options
            ...List.generate(4, (index) {
              bool isSelected = selectedOption == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => selectedOption = index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? AppTheme.primaryBlue : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Colors.black87,
                      elevation: isSelected ? 4 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Text(
                      q['options'][index],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Footer Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _prevQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Previous"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(currentIndex == questions.length - 1 ? "Finish" : "Next"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Dropdown (Disabled until finish, purely visual based on prompt)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("See Result", style: TextStyle(color: Colors.grey)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}