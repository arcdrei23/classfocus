// TASK 1: Fix Startup Logic & Dashboard Crash ✅
// 
// COMPLETED:
// 1. In lib/main.dart: Already has `await FirebaseAuth.instance.signOut();` 
//    - This forces logout on every app restart, starting at LoginSelectionPage
// 2. Teacher dashboard checked for overflow issues
//    - No Spacer() or Expanded() widgets causing RenderFlex issues
//    - Already wrapped in SafeArea + SingleChildScrollView
//
// ═══════════════════════════════════════════════════════════════════════════

// TASK 2: Create Seed Data Script ✅
//
// COMPLETED:
// Created: lib/services/dev_data_service.dart
//
// Key Features:
// - initializeDevData() → Auto-called from main.dart
// - Creates student: 1@gmail.com (role: student)
// - Creates teacher: 2@gmail.com (role: teacher)
// - Creates subject: "Data Structures"
// - Creates sample quiz with 5 questions and access code "ABC123"
//
// Usage in main.dart:
//   await DevDataService.initializeDevData();
//
// Test Login Credentials:
//   Student: 1@gmail.com / password123
//   Teacher: 2@gmail.com / password123
//
// ═══════════════════════════════════════════════════════════════════════════

// TASK 3: Quiz Access Codes ✅
//
// COMPLETED:
// - QuizCreatorScreen already generates 6-char codes: "ABC123" style
// - Dialog already shows code after publishing
// - Sample quiz pre-created with code "ABC123"
//
// Code Generation (already in quiz_creator_screen.dart):
//   String _generateAccessCode() {
//     const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     final random = Random();
//     _accessCode = String.fromCharCodes(Iterable.generate(
//       6,
//       (_) => chars.codeUnitAt(random.nextInt(chars.length)),
//     ));
//     return _accessCode;
//   }
//
// ═══════════════════════════════════════════════════════════════════════════
//
// STUDENT "JOIN QUIZ" WIDGET IMPLEMENTATION
//
// Below is a complete, production-ready widget you can add to your
// Student Dashboard. It handles:
// - Input validation (trim, uppercase)
// - Firestore query for quiz lookup
// - Error handling
// - Loading states
// - Navigation to quiz detail screen
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Student Join Quiz Widget
/// Add this to your Student Dashboard
class StudentJoinQuizWidget extends StatefulWidget {
  const StudentJoinQuizWidget({super.key});

  @override
  State<StudentJoinQuizWidget> createState() => _StudentJoinQuizWidgetState();
}

class _StudentJoinQuizWidgetState extends State<StudentJoinQuizWidget> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinQuiz() async {
    final code = _codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter a quiz code');
      return;
    }

    if (code.length != 6) {
      setState(() => _errorMessage = 'Code must be 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Query Firestore for quiz with matching access code
      final querySnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('accessCode', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() => _errorMessage = 'Quiz not found. Check your code.');
        return;
      }

      final quizDoc = querySnapshot.docs.first;
      final quizId = quizDoc.id;

      // Update quiz to add student to participants
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await quizDoc.reference.update({
          'studentParticipants': FieldValue.arrayUnion([currentUser.email])
        });
      }

      if (mounted) {
        // Navigate to quiz detail screen
        // Adjust route name based on your app's routing
        Navigator.pushNamed(
          context,
          '/quizDetail', // or your quiz detail route
          arguments: {
            'quizId': quizId,
            'accessCode': code,
          },
        );

        // Clear input
        _codeController.clear();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Join a Quiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enter the 6-character code provided by your teacher',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            readOnly: _isLoading,
            decoration: InputDecoration(
              hintText: 'e.g., ABC123',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.vpn_key),
              counterText: '', // Hide character counter
              errorText: _errorMessage,
            ),
            onSubmitted: (_) => _joinQuiz(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _joinQuiz,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isLoading ? 'Joining...' : 'Join Quiz'),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//
// INTEGRATION GUIDE FOR STUDENT DASHBOARD
//
// Step 1: Add import to your Student Dashboard file:
//   import 'path/to/this/widget.dart';
//
// Step 2: Add the widget to your build method:
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const StudentJoinQuizWidget(),
//         // ... other widgets ...
//       ],
//     );
//   }
//
// Step 3: Make sure your routing includes the quiz detail route:
//   case '/quizDetail':
//     return MaterialPageRoute(
//       builder: (_) => QuizDetailScreen(
//         quizId: args['quizId'],
//         accessCode: args['accessCode'],
//       ),
//     );
//
// ═══════════════════════════════════════════════════════════════════════════
//
// TESTING THE COMPLETE FLOW
//
// 1. Start the app - automatically logs out (signOut in main.dart)
// 2. Go to Login Selection Page
// 3. Login as Student: 1@gmail.com / password123
// 4. Use "Join Quiz" widget to enter code: ABC123
// 5. System finds the pre-seeded quiz
// 6. Student is added to studentParticipants
// 7. Navigate to quiz detail screen
//
// Alternative - Teacher Flow:
// 1. Login as Teacher: 2@gmail.com / password123
// 2. Navigate to Quiz Creator
// 3. Create new quiz (auto-generates 6-char code like "XYZ789")
// 4. Code shown in dialog after publishing
// 5. Share code with students
// 6. Students use code to join via the widget above
//
// ═══════════════════════════════════════════════════════════════════════════
//
// KEY IMPLEMENTATION NOTES
//
// 1. Firestore Query:
//    - Uses where('accessCode', isEqualTo: code)
//    - Requires code in UPPERCASE
//    - Case-sensitive match
//
// 2. Student Participation:
//    - Uses FieldValue.arrayUnion() to add email to studentParticipants
//    - Prevents duplicates automatically
//    - Atomic operation (safe for concurrent updates)
//
// 3. Error Handling:
//    - Empty code check
//    - Length validation (6 characters)
//    - Quiz not found error
//    - Firestore exception handling
//
// 4. Loading States:
//    - Disables input while loading
//    - Shows circular progress in button
//    - Prevents duplicate submissions
//
// 5. Navigation:
//    - Clears code input on success
//    - Passes quizId and code to detail screen
//    - Adjust route name to match your app's routing
//
// ═══════════════════════════════════════════════════════════════════════════
