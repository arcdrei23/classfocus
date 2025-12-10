# Firebase Setup Guide for ClassFocus

This guide will help you set up Firebase for your ClassFocus Flutter application.

## Prerequisites

1. A Google account
2. Flutter SDK installed
3. Android Studio or Xcode (for platform-specific setup)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Enter your project name (e.g., "ClassFocus")
4. Follow the setup wizard:
   - Disable Google Analytics (optional) or enable it if you want
   - Click "Create project"

## Step 2: Add Android App to Firebase

1. In Firebase Console, click the Android icon (or "Add app")
2. Enter your Android package name: `com.example.trial`
   - You can find this in `android/app/build.gradle.kts` under `applicationId`
3. Enter app nickname (optional): "ClassFocus Android"
4. Enter SHA-1 (optional for now, required for some features)
5. Click "Register app"
6. Download `google-services.json`
7. Place the file in: `android/app/google-services.json`

## Step 3: Add iOS App to Firebase (if developing for iOS)

1. In Firebase Console, click the iOS icon
2. Enter your iOS bundle ID (found in `ios/Runner/Info.plist` under `CFBundleIdentifier`)
3. Enter app nickname (optional)
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Open Xcode and add the file to the `ios/Runner` directory
7. Make sure it's added to the Runner target

## Step 4: Enable Firebase Services

### Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. (Optional) Enable other sign-in methods as needed

### Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to your users)
5. Click "Enable"

### Storage (Optional)
1. In Firebase Console, go to "Storage"
2. Click "Get started"
3. Start in test mode
4. Choose a location
5. Click "Done"

## Step 5: Install Dependencies

The Firebase dependencies have already been added to `pubspec.yaml`. Run:

```bash
cd classfocus
flutter pub get
```

## Step 6: Verify Setup

1. Make sure `google-services.json` is in `android/app/` directory
2. Make sure `GoogleService-Info.plist` is in `ios/Runner/` directory (for iOS)
3. Run the app:
   ```bash
   flutter run
   ```

## Troubleshooting

### Android Issues

- **Error: "google-services.json not found"**
  - Make sure the file is in `android/app/google-services.json`
  - Clean and rebuild: `flutter clean && flutter pub get && flutter run`

- **Error: "Default FirebaseApp is not initialized"**
  - Make sure Firebase is initialized in `main.dart`
  - Check that `google-services.json` is correctly placed

### iOS Issues

- **Error: "GoogleService-Info.plist not found"**
  - Make sure the file is added to Xcode project
  - Check that it's included in the Runner target

- **CocoaPods issues**
  - Run: `cd ios && pod install && cd ..`
  - Then: `flutter clean && flutter pub get`

## Next Steps

After Firebase is set up, you can:

1. **Update AuthService** to use Firebase Authentication instead of mock users
2. **Create Firestore collections** for:
   - Users
   - Quizzes
   - Lessons
   - Badges
   - Leaderboard
3. **Implement real-time data** using Firestore streams
4. **Add file uploads** using Firebase Storage for profile images

## Security Rules

⚠️ **Important**: Update Firestore security rules before deploying to production:

1. Go to Firestore Database → Rules
2. Replace test mode rules with proper security rules
3. Example rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can only read/write their own data
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Quizzes are readable by all authenticated users
       match /quizzes/{quizId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && 
           get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'teacher';
       }
     }
   }
   ```

## Support

For more information, visit:
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Documentation](https://firebase.google.com/docs)

