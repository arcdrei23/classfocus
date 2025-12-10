// lib/screens/teacher/quiz_creator_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/quiz_provider.dart';
import '../../models/quiz_model.dart';

class QuizCreatorScreen extends StatefulWidget {
  const QuizCreatorScreen({super.key});

  @override
  State<QuizCreatorScreen> createState() => _QuizCreatorScreenState();
}

class _QuizCreatorScreenState extends State<QuizCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedSubject = 'Data Structures';
  final _durationController = TextEditingController(text: '7');
  final List<Question> _questions = [];
  bool _isPublished = false;
  String _accessCode = '';

  final List<String> _subjects = [
    'Data Structures',
    'Networking',
    'Database Systems',
    'Web Dev',
    'HCI',
    'OS',
    'OOP',
    'Capstone',
  ];

  @override
  void initState() {
    super.initState();
    _generateAccessCode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String _generateAccessCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    _accessCode = String.fromCharCodes(Iterable.generate(
      6,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    return _accessCode;
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(
        onSave: (question) {
          setState(() {
            _questions.add(question);
          });
        },
      ),
    );
  }

  Future<void> _saveAndPublish() async {
    if (_formKey.currentState!.validate()) {
      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one question')),
        );
        return;
      }

      final quizId = DateTime.now().millisecondsSinceEpoch.toString();
      final quiz = QuizModel(
        id: quizId,
        title: _titleController.text,
        subject: _selectedSubject,
        questions: _questions,
        isPublished: _isPublished,
        durationMinutes: int.tryParse(_durationController.text) ?? 7,
      );

      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.addQuiz(quiz);

      // Save to Firestore with access code
      try {
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
            .set({
          'id': quizId,
          'title': _titleController.text,
          'subject': _selectedSubject,
          'questions': _questions.map((q) => {
            'id': q.id,
            'questionText': q.questionText,
            'options': q.options,
            'correctAnswerIndex': q.correctAnswerIndex,
          }).toList(),
          'isPublished': _isPublished,
          'durationMinutes': int.tryParse(_durationController.text) ?? 7,
          'accessCode': _accessCode,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
        });

        // Show access code dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Quiz Access Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Share this code with students to join the quiz:'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _accessCode,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving quiz: $e')),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isPublished
                ? 'Quiz published successfully!'
                : 'Quiz saved as draft.'),
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Quiz'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Quiz Title',
                  labelStyle: const TextStyle(color: AppTheme.secondaryText),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Subject Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: const TextStyle(color: AppTheme.secondaryText),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                dropdownColor: AppTheme.surface,
                style: const TextStyle(color: Colors.white),
                items: _subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedSubject = value!);
                },
              ),
              const SizedBox(height: 20),
              // Duration Field
              TextFormField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  labelStyle: const TextStyle(color: AppTheme.secondaryText),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Published Toggle
              SwitchListTile(
                title: const Text(
                  'Publish Quiz',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Published quizzes will be visible to students',
                  style: TextStyle(color: AppTheme.secondaryText),
                ),
                value: _isPublished,
                onChanged: (value) {
                  setState(() => _isPublished = value);
                },
                activeColor: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 30),
              // Questions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questions (${_questions.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Questions List
              if (_questions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'No questions added yet',
                      style: TextStyle(color: AppTheme.secondaryText),
                    ),
                  ),
                )
              else
                ...List.generate(_questions.length, (index) {
                  final question = _questions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${question.questionText}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...question.options.asMap().entries.map((entry) {
                          final isCorrect = entry.key == question.correctAnswerIndex;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${entry.key + 1}. ${entry.value} ${isCorrect ? '✓' : ''}',
                              style: TextStyle(
                                color: isCorrect ? Colors.green : AppTheme.secondaryText,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 40),
              // Save & Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isPublished ? 'Save & Publish' : 'Save as Draft',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionDialog extends StatefulWidget {
  final Function(Question) onSave;

  const _QuestionDialog({required this.onSave});

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _correctAnswer = 0;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    final options = _optionControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .toList();

    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 2 options')),
      );
      return;
    }

    if (_correctAnswer >= options.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid correct answer')),
      );
      return;
    }

    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questionText: _questionController.text,
      options: options,
      correctAnswerIndex: _correctAnswer,
    );

    widget.onSave(question);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: const Text(
        'Add Question',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Question',
                labelStyle: TextStyle(color: AppTheme.secondaryText),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.secondaryText),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Options:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _correctAnswer,
                      onChanged: (value) {
                        setState(() => _correctAnswer = value!);
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[index],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Option ${index + 1}',
                          hintStyle: const TextStyle(color: AppTheme.secondaryText),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.secondaryText),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

