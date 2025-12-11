# 🚀 Quick Reference - Quiz Access Code Implementation

## Test Credentials
```
STUDENT LOGIN:
  Email: 1@gmail.com
  Password: password123

TEACHER LOGIN:
  Email: 2@gmail.com
  Password: password123
```

## Pre-seeded Quiz Code
```
Code: ABC123
Title: Data Structures Fundamentals
Duration: 10 minutes
Questions: 5
```

---

## Testing Steps

### 1. Student Joins Quiz
```
1. Open app → Automatically logged out
2. Select Student → Login with 1@gmail.com
3. Dashboard → Find "Join Quiz" widget
4. Enter Code → ABC123
5. Success → Navigate to quiz screen
```

### 2. Teacher Creates Quiz
```
1. Open app → Automatically logged out
2. Select Teacher → Login with 2@gmail.com
3. Dashboard → Click "Quiz" button
4. Fill Details → Title, Subject, Questions
5. Publish → Code dialog shows (e.g., K4M9QP)
6. Share Code → Give to students
```

### 3. Student Joins New Quiz
```
1. Student Dashboard → Join Quiz widget
2. Enter Code → K4M9QP
3. System finds quiz
4. Student added to participants
5. Navigate to quiz
```

---

## File Locations

| What | Where |
|------|-------|
| Auto-create accounts | `lib/services/dev_data_service.dart` |
| SignOut on startup | `lib/main.dart` line 28 |
| Join widget code | `IMPLEMENTATION_GUIDE.dart` |
| Access code logic | `lib/screens/teacher/quiz_creator_screen.dart` |
| Quiz model | `lib/models/quiz_model.dart` |

---

## Key Code Snippets

### Enable Dev Data (in main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();
  await DevDataService.initializeDevData(); // <- Adds this
  
  runApp(const ClassFocusApp());
}
```

### Query Quiz by Code (in widget)
```dart
final querySnapshot = await FirebaseFirestore.instance
    .collection('quizzes')
    .where('accessCode', isEqualTo: code.toUpperCase())
    .limit(1)
    .get();
```

### Add Student to Quiz (in widget)
```dart
await quizDoc.reference.update({
  'studentParticipants': FieldValue.arrayUnion([
    currentUser.email
  ])
});
```

### Generate Access Code (already in creator)
```dart
String _generateAccessCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    6,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
```

---

## Firestore Data Structure

```
users/
  ├─ {studentUid}
  │  ├─ email: "1@gmail.com"
  │  ├─ role: "student"
  │  └─ name: "Student One"
  │
  └─ {teacherUid}
     ├─ email: "2@gmail.com"
     ├─ role: "teacher"
     └─ name: "Teacher One"

quizzes/
  └─ quiz_sample_001
     ├─ title: "Data Structures Fundamentals"
     ├─ accessCode: "ABC123"
     ├─ createdBy: "2@gmail.com"
     ├─ studentParticipants: ["1@gmail.com"]
     ├─ questions: [...]
     └─ isPublished: true

subjects/
  └─ {subjectId}
     ├─ name: "Data Structures"
     ├─ createdBy: "2@gmail.com"
     └─ description: "..."
```

---

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| "Quiz not found" | Check code is UPPERCASE (ABC123 not abc123) |
| RenderFlex overflow | Already fixed - using SafeArea + scroll |
| Undefined FirebaseAuth | Import added to teacher_dashboard.dart |
| toMap() not found | QuizModel already has toMap/fromMap |
| Code not saving | Access code auto-generated in initState |

---

## Integration Checklist

- [x] dev_data_service.dart created
- [x] main.dart updated with SignOut
- [x] main.dart updated with DevDataService call
- [x] FirebaseAuth import added to teacher dashboard
- [x] No compilation errors
- [x] Access codes already working
- [x] Student join widget provided

**Ready to test!** ✅
