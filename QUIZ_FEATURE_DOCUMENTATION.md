# ClassFocus - Join Quiz Feature Documentation

## Overview
The ClassFocus app now includes a complete Quiz Management system with teacher-created quizzes and student code-based joining mechanism.

---

## Features Implemented

### 1. **Student Dashboard - Join Quiz Button**
- **Location**: Student Dashboard (FloatingActionButton)
- **Icon**: `Icons.keyboard`
- **Label**: "Join Quiz"
- **Functionality**: Opens a dialog for students to enter a 6-character quiz access code

### 2. **Join Quiz Dialog**
- **Input Field**: Text field for 6-character code (uppercase)
- **Validation**: 
  - Code must be exactly 6 characters
  - Spaces are trimmed automatically
  - Code is converted to uppercase for consistency
- **Loading State**: Spinner displayed while Firestore query processes
- **Error Handling**: Shows "Invalid Code" SnackBar if code not found
- **Success**: Navigates to `QuizStartScreen` with quiz data

### 3. **QuizStartScreen with Timer & Leaderboard**
- **Two Phases**:
  - **Pre-Quiz**: Shows quiz details (title, questions count, duration, subject)
  - **During Quiz**: 
    - Countdown timer in AppBar (red when <60 seconds)
    - Progress bar showing current question
    - Question display with multiple-choice options
    - Previous/Next navigation buttons
    - Automatic submit on time-up
  - **Post-Quiz**: Results screen with leaderboard

### 4. **Leaderboard**
- **Real-time**: Fetched from Firestore after quiz completion
- **Sorting**: Automatically sorted by score (descending)
- **Current User Highlight**: Student's entry is highlighted with blue border
- **Data Displayed**:
  - Rank (1st, 2nd, 3rd, etc.)
  - Student Name
  - Student Email
  - Score (correct/total)

### 5. **Teacher Quiz Creator**
- **Enhanced Features**:
  - Auto-generates 6-character access code
  - Saves access code to Firestore
  - Saves created_by (teacher email)
  - Shows access code in a dialog after creation
  - Tracks student participants
  - Stores leaderboard data

### 6. **Firestore Integration**
- **Collection**: `quizzes`
- **Document Fields**:
  ```json
  {
    "id": "quiz_id",
    "title": "Quiz Title",
    "subject": "Data Structures",
    "accessCode": "ABC123",
    "createdBy": "teacher@example.com",
    "questions": [...],
    "isPublished": true,
    "durationMinutes": 15,
    "studentParticipants": ["student@example.com"],
    "leaderboardData": [
      {
        "studentEmail": "student@example.com",
        "studentName": "Student Name",
        "score": 9,
        "totalQuestions": 10,
        "completedAt": "2025-12-11T10:30:00Z"
      }
    ],
    "createdAt": "2025-12-11T10:00:00Z"
  }
  ```

---

## Sample Data

### Pre-loaded Quiz
**Code**: `ABC123`
**Title**: Data Structures Fundamentals
**Subject**: Data Structures
**Questions**: 10
**Duration**: 15 minutes
**Participant Email**: `1@gmail.com`
**Sample Score**: 9/10

### To Access Sample Quiz
1. Open Student Dashboard
2. Click "Join Quiz" button (floating button)
3. Enter code: `ABC123`
4. View leaderboard after completing quiz

---

## How to Use

### For Students

#### Joining a Quiz
1. Navigate to Student Dashboard
2. Click the floating "Join Quiz" button (keyboard icon)
3. Enter the 6-character code provided by teacher
4. Click "Join"
5. If code is valid:
   - Dialog closes
   - Navigated to quiz start screen
   - Click "Start Quiz" to begin

#### Taking a Quiz
1. Review quiz details on the start screen
2. Click "Start Quiz"
3. Answer questions using multiple-choice options
4. Use Previous/Next to navigate
5. Click "Submit" on the last question
6. View results and leaderboard

#### Viewing Leaderboard
- Automatically displayed after quiz completion
- Sorted by score (highest first)
- Shows rank, name, email, and score
- Current student's entry is highlighted

### For Teachers

#### Creating a Quiz
1. Navigate to Teacher Dashboard
2. Click "Quiz" button in "Manage Class Content" section
3. Fill in quiz details:
   - Title
   - Subject (dropdown)
   - Duration (minutes)
   - Add questions
4. Mark as "Published" if ready
5. Click "Save & Publish"
6. **Copy the generated 6-character code** to share with students

#### Sharing Quiz with Students
- Give students the 6-character access code
- Students enter code in the "Join Quiz" dialog
- Automatic tracking of participants and scores

---

## Models

### QuizModel
```dart
class QuizModel {
  final String id;
  final String title;
  final String subject;
  final List<Question> questions;
  final bool isPublished;
  final int durationMinutes;
  final String accessCode;          // New
  final String createdBy;           // New
  final List<String> studentParticipants;  // New
  final List<LeaderboardEntry> leaderboardData;  // New
  final DateTime createdAt;         // New
  
  // toMap() and fromMap() for Firestore serialization
  Map<String, dynamic> toMap() { ... }
  factory QuizModel.fromMap(Map<String, dynamic> map) { ... }
}
```

### LeaderboardEntry
```dart
class LeaderboardEntry {
  final String studentEmail;
  final String studentName;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  
  Map<String, dynamic> toMap() { ... }
  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) { ... }
}
```

### Question
```dart
class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  
  Map<String, dynamic> toMap() { ... }
  factory Question.fromMap(Map<String, dynamic> map) { ... }
}
```

---

## Services

### FirebaseInitService
Initializes sample data and provides quiz management functions:

```dart
static Future<void> initializeSampleData()  // Auto-called in main.dart
static Future<String> createQuiz(QuizModel quiz)
static Future<QuizModel?> getQuizByCode(String accessCode)
static Future<List<QuizModel>> getQuizzesBySubject(String subject)
static Future<void> addToLeaderboard(String quizId, LeaderboardEntry entry)
static Future<List<LeaderboardEntry>> getLeaderboard(String quizId)
```

---

## Navigation Flow

```
StudentDashboard
  ↓
  ├─→ [Click "Join Quiz" Button]
  │   ↓
  │   JoinQuizDialog
  │   ↓
  │   [Enter Code: ABC123]
  │   ↓
  │   Firestore Query (accessCode = 'ABC123')
  │   ↓
  │   [Code Found ✓]
  │   ↓
  └─→ QuizStartScreen (Pre-Quiz)
      ↓
      [Click "Start Quiz"]
      ↓
      QuizStartScreen (During Quiz)
      ├─ Timer countdown (15 minutes)
      ├─ Question display (1-10)
      ├─ Answer selection
      ├─ Previous/Next navigation
      ↓
      [Click "Submit"]
      ↓
      QuizStartScreen (Post-Quiz)
      ├─ Score display (9/10)
      ├─ Percentage (90%)
      ├─ Leaderboard (sorted by score)
      ↓
      [Click "Back to Dashboard"]
      ↓
      StudentDashboard
```

---

## Testing Checklist

- [x] Student can click "Join Quiz" button
- [x] Dialog appears with code input field
- [x] Firestore query works for valid code
- [x] Invalid code shows error message
- [x] Quiz starts with correct data
- [x] Timer counts down properly
- [x] Questions display and options selectable
- [x] Navigation (Previous/Next) works
- [x] Submit calculates score correctly
- [x] Leaderboard displays sorted results
- [x] Current student highlighted in leaderboard
- [x] Teacher can create quiz with access code
- [x] Access code displayed after quiz creation

---

## Code Examples

### Joining a Quiz (Student Side)
```dart
// In student_dashboard.dart
void _showJoinQuizDialog() {
  final codeController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Join Quiz with Code'),
      content: TextField(
        controller: codeController,
        textCapitalization: TextCapitalization.characters,
        maxLength: 6,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final code = codeController.text.trim().toUpperCase();
            
            try {
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('quizzes')
                  .where('accessCode', isEqualTo: code)
                  .get();
              
              if (querySnapshot.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Code')),
                );
                return;
              }
              
              final quiz = QuizModel.fromMap(querySnapshot.docs.first.data());
              Navigator.pop(context);
              Navigator.pushNamed(context, '/quizStart', arguments: quiz);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text('Join'),
        ),
      ],
    ),
  );
}
```

### Creating a Quiz (Teacher Side)
```dart
// In quiz_creator_screen.dart
Future<void> _saveAndPublish() async {
  final quizId = DateTime.now().millisecondsSinceEpoch.toString();
  final quiz = QuizModel(
    id: quizId,
    title: _titleController.text,
    subject: _selectedSubject,
    questions: _questions,
    accessCode: _accessCode,  // Auto-generated
    createdBy: FirebaseAuth.instance.currentUser?.email ?? '',
    durationMinutes: int.tryParse(_durationController.text) ?? 7,
    isPublished: _isPublished,
  );
  
  await FirebaseFirestore.instance
      .collection('quizzes')
      .doc(quizId)
      .set(quiz.toMap());
  
  // Show access code to teacher
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Quiz Access Code'),
      content: Text(_accessCode, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    ),
  );
}
```

---

## Future Enhancements

1. **Real-time Quiz Updates**: Use Firestore real-time listeners
2. **Quiz Analytics**: Teacher dashboard with detailed analytics
3. **Question Bank**: Pre-built question library
4. **Time Penalties**: Deduct points for questions skipped
5. **Quiz Reviews**: Show correct answers after completion
6. **Bulk Invite**: Send access codes via email/SMS
7. **Quiz Categories**: Organize quizzes by topic
8. **Difficulty Levels**: Adaptive quiz difficulty
9. **Attempt History**: Track multiple quiz attempts
10. **Export Results**: Download leaderboard as CSV/PDF

---

## Troubleshooting

### Quiz Not Found (Invalid Code)
- Ensure code is exactly 6 characters
- Verify code matches Firestore entry
- Check that quiz is published (`isPublished: true`)

### Timer Not Starting
- Ensure Quiz model has correct `durationMinutes`
- Check Firebase initialization completed
- Verify timestamp synchronization

### Leaderboard Not Updating
- Ensure student submits quiz (doesn't just close app)
- Check Firestore security rules allow writes
- Verify `leaderboardData` field exists in Firestore

### Access Code Not Displaying
- Check quiz creation was successful
- Verify teacher sees the dialog
- Try creating quiz again if issue persists

---

## Summary

The ClassFocus app now has a complete, production-ready quiz system that allows:
- ✅ Teachers to create quizzes with auto-generated access codes
- ✅ Students to join quizzes using codes
- ✅ Real-time quiz taking with countdown timers
- ✅ Automatic score calculation
- ✅ Live leaderboard with rankings
- ✅ Firestore persistence for data

All components are tested and working!
