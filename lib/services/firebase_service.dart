// lib/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Get Firebase Auth instance
  static FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _auth!;
  }

  // Get Firestore instance
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _firestore!;
  }

  // Get Storage instance
  static FirebaseStorage get storage {
    if (_storage == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _storage!;
  }

  // Check if Firebase is initialized
  static bool get isInitialized => _auth != null && _firestore != null && _storage != null;

  // Get current user
  static User? get currentUser => _auth?.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;
}

