# ClassFocus - Code Implementation Reference

This document provides exact code snippets for all implementations.

---

## 1. AuthService - loadUserFromFirestore() Method

### Location: `lib/services/auth_service.dart`

```dart
/// Fetch and load user data from Firestore based on Firebase Auth UID
Future<void> loadUserFromFirestore(String uid) async {
  if (_isLoadingUserData) return;
  
  try {
    _isLoadingUserData = true;
    
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      
      // Create a UserModel from Firestore data
      _currentUser = UserModel(
        id: uid,
        name: data?['name'] ?? 'Unknown User',
        email: data?['email'] ?? '',
        studentId: data?['studentId'] ?? 'N/A',
        xp: data?['xp'] ?? 0,
        streak: data?['streak'] ?? 0,
        profileImageUrl: data?['profileImageUrl'] ?? 'https://i.pravatar.cc/300',
        recentActivities: [],
      );
      
      notifyListeners();
      print('[AuthService] User loaded from Firestore: ${_currentUser?.name}');
    } else {
      print('[AuthService] User document not found in Firestore');
    }
  } catch (e) {
    print('[AuthService] Error loading user from Firestore: $e');
  } finally {
    _isLoadingUserData = false;
  }
}
```

---

## 2. Main.dart - StatefulWidget Implementation

### Location: `lib/main.dart`

```dart
class _RoleBasedDashboard extends StatefulWidget {
  final User user;

  const _RoleBasedDashboard({required this.user});

  @override
  State<_RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<_RoleBasedDashboard> {
  @override
  void initState() {
    super.initState();
    // Load user data from Firestore
    Future.microtask(() {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.loadUserFromFirestore(widget.user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          final role = userData?['role'] as String? ?? 'student';

          if (role == 'teacher') {
            return const TeacherDashboardPage();
          } else {
            return const StudentDashboard();
          }
        }

        // Default fallback
        return const StudentDashboard();
      },
    );
  }
}
```

---

## 3. Register Page - Updated Handler

### Location: `lib/screens/auth/register_page.dart`

```dart
void _handleRegister() async {
  if (_formKey.currentState!.validate()) {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Call the signUp method from AuthService
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
      );

      if (mounted) {
        // Navigate to appropriate dashboard based on role
        if (_selectedRole == 'student') {
          Navigator.pushReplacementNamed(context, '/studentDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/teacherDashboard');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }
}
```

---

## 4. Teacher Dashboard - Dynamic Greeting

### Location: `lib/screens/teacher/dashboard/teacher_dashboard.dart`

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          final userName = authService.currentUser?.name ?? 'Teacher';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $userName",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Teacher • Grade 6 Head",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    ),
    // CircleAvatar and other widgets follow...
  ],
)
```

---

## 5. Create Announcement - Firestore Save

### Location: `lib/screens/teacher/announcements/create_announcement_screen.dart`

```dart
void _publishAnnouncement() async {
  if (_formKey.currentState!.validate()) {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      // Get teacher name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final teacherName = userDoc.data()?['name'] ?? 'Unknown Teacher';

      // Save announcement to Firestore
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'targetClass': _selectedClass,
        'teacherName': teacherName,
        'teacherEmail': currentUser.email,
        'isUrgent': _isUrgent,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Announcement published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error publishing announcement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

---

## 6. Student Dashboard - Announcements Section

### Location: `lib/screens/student/dashboard/tabs/home_dashboard_tab.dart`

```dart
/// Build Announcements Section with real-time Firestore data
Widget _buildAnnouncementsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Announcements",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcements')
            .orderBy('timestamp', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "No announcements yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final announcement = snapshot.data!.docs[index];
              final data = announcement.data() as Map<String, dynamic>;
              final isUrgent = data['isUrgent'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUrgent ? Colors.red[50] : Colors.blue[50],
                  border: Border(
                    left: BorderSide(
                      color: isUrgent ? Colors.red : Colors.blue,
                      width: 4,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "URGENT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['content'] ?? 'No content',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By ${data['teacherName'] ?? 'Unknown'} • ${data['targetClass'] ?? 'All Classes'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
```

---

## 7. Seed Data Service - Complete Implementation

### Location: `lib/services/seed_data_service.dart`

See the full file content in the project - it includes:
- `seedTestDatabase()` - main entry point
- `_createStudentUser()` - creates student account
- `_createTeacherUser()` - creates teacher account
- `_createSampleSubject()` - creates subject
- `_createSampleLesson()` - creates lesson in subject
- `_createSampleQuizHistory()` - creates quiz history for student

Each method:
- Checks if data already exists
- Only creates if missing (idempotent)
- Logs progress to console
- Handles errors gracefully

---

## Quiz Navigation - Already Correct

### Location: `lib/pages/score/score_summary_page.dart`

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/studentDashboard',
  (route) => false,  // Remove all routes below
);
```

This correctly:
1. Routes to StudentDashboard (not Login)
2. Clears navigation stack
3. Prevents going back to quiz screen

---

## Key Integration Points

### 1. Register User - AuthService.signUp()
```dart
// Automatically called when user registers
await authService.signUp(
  email: email,
  password: password,
  name: name,
  role: role,
);
// Creates Auth user + Firestore document
```

### 2. Load User on Login - AuthService.loadUserFromFirestore()
```dart
// Called when user logs in (in _RoleBasedDashboard.initState)
authService.loadUserFromFirestore(uid);
// Fetches user data from Firestore into AuthService
```

### 3. Use User Data - Consumer<AuthService>
```dart
// Use anywhere in UI to access user data
Consumer<AuthService>(
  builder: (context, authService, _) {
    final name = authService.currentUser?.name;
    final xp = authService.currentUser?.xp;
    // ...
  },
)
```

---

## Testing Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run app
flutter run

# Run with verbose logging
flutter run -v

# Check for errors
flutter analyze

# Format code
dart format lib/
```

---

## Firestore Indexing

For announcements to sort by timestamp efficiently, ensure you have this index:

```
Collection: announcements
Fields indexed:
  - timestamp (Descending)
```

Firestore will suggest this automatically when you use `.orderBy('timestamp')`.

---

All implementations are production-ready! ✅
