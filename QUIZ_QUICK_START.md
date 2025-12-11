# Quick Start Guide - Quiz Feature

## Setup Instructions

### 1. **Build & Run the App**
```powershell
cd C:\Users\Carl\OneDrive\Desktop\project\trial\classfocus
flutter clean
flutter pub get
flutter run
```

### 2. **Access Sample Quiz**

#### Student Account
1. Login with any email (e.g., `1@gmail.com`)
2. Navigate to Student Dashboard
3. Click floating "Join Quiz" button (keyboard icon)
4. **Enter Code**: `ABC123`
5. Click "Join"

#### What You'll See
- Quiz: **Data Structures Fundamentals**
- 10 questions
- 15 minutes duration
- Leaderboard with sample student (1@gmail.com with score 9/10)

### 3. **Create Your Own Quiz**

#### Teacher Account
1. Login as teacher
2. Click "Quiz" button in dashboard
3. Fill in:
   - Title: e.g., "Advanced Algorithms"
   - Subject: e.g., "Data Structures"
   - Duration: e.g., 20 minutes
   - Add 5-10 questions with options
4. Check "Published"
5. Click "Save & Publish"
6. **Copy the 6-character code** displayed
7. Share code with students

### 4. **Test Complete Flow**

**Step 1: Create Quiz as Teacher**
- Open teacher dashboard
- Click "Quiz" 
- Add 3 questions
- Publish and copy code (e.g., `XYZ789`)

**Step 2: Join Quiz as Student**
- Switch to student account
- Click "Join Quiz"
- Paste code `XYZ789`
- Click "Join"

**Step 3: Take Quiz**
- Click "Start Quiz"
- Answer all questions
- Click "Submit"
- View leaderboard

---

## Key Code Locations

| Feature | File |
|---------|------|
| Student Join Button | `lib/screens/student/dashboard/student_dashboard.dart` |
| Quiz Taking | `lib/screens/student/quiz_start_screen.dart` |
| Teacher Quiz Creator | `lib/screens/teacher/quiz_creator_screen.dart` |
| Quiz Model | `lib/models/quiz_model.dart` |
| Firebase Service | `lib/services/firebase_init_service.dart` |
| Sample Data Init | `lib/main.dart` (line ~30) |
| Routes | `lib/routes.dart` |

---

## Database Structure

All quiz data is stored in Firestore under:
```
quizzes/
  ├── quiz_001/
  │   ├── id: "quiz_001"
  │   ├── title: "Data Structures Fundamentals"
  │   ├── subject: "Data Structures"
  │   ├── accessCode: "ABC123"
  │   ├── createdBy: "teacher@example.com"
  │   ├── questions: [...]
  │   ├── studentParticipants: ["1@gmail.com"]
  │   ├── leaderboardData: [...]
  │   └── createdAt: "2025-12-11T..."
  │
  ├── <new-quiz-id>/
  │   └── ...
```

---

## Testing Scenarios

### ✅ Valid Code Entry
1. Student enters: `ABC123`
2. Expected: Quiz opens, can see all questions
3. Verify: Timer starts, questions display

### ✅ Invalid Code Entry
1. Student enters: `WRONG1`
2. Expected: SnackBar shows "Invalid Code"
3. Verify: Dialog stays open, can retry

### ✅ Quiz Submission
1. Student answers questions
2. Clicks "Submit"
3. Expected: Score calculated, leaderboard shows
4. Verify: Student rank and score appear

### ✅ Leaderboard Display
1. After quiz completes
2. Expected: All participants ranked by score
3. Verify: Current student highlighted with blue border

### ✅ Teacher Quiz Creation
1. Teacher fills all fields
2. Clicks "Publish"
3. Expected: Access code dialog appears
4. Verify: Code is 6 characters, in UPPERCASE

---

## Debugging

### Check Firestore Connection
```dart
// In any screen, print to verify Firebase:
print('Current user: ${FirebaseAuth.instance.currentUser?.email}');
print('Firestore: ${FirebaseFirestore.instance}');
```

### Check Sample Data Loaded
1. Open Firebase Console
2. Go to `Firestore Database`
3. Check `quizzes` collection
4. Should see `quiz_001` document

### View Logs
```powershell
# Run with verbose logging
flutter run -v
```

---

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| "Invalid Code" when code is correct | Clear app cache, rebuild: `flutter clean && flutter run` |
| Quiz timer shows 00:00 | Check `durationMinutes` field in Firestore is > 0 |
| Leaderboard empty | Ensure student actually submitted quiz (not just closed) |
| Access code not displayed | Refresh teacher dashboard or create new quiz |
| Firestore errors | Check Google Cloud Firestore rules allow read/write |

---

## Congratulations! 🎉

You now have a fully working quiz system with:
- ✅ Student code-based joining
- ✅ Live countdown timers
- ✅ Automatic scoring
- ✅ Real-time leaderboards
- ✅ Firebase persistence

**Enjoy using ClassFocus!**
