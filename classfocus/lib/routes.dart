// lib/routes.dart
import 'package:flutter/material.dart';

// =========================
// AUTH SCREENS
// =========================
import 'package:trial/screens/landing/landing_page.dart';
import 'package:trial/screens/auth/login_selection_page.dart';
import 'package:trial/screens/auth/register_page.dart';
import 'package:trial/screens/auth/simple_login_screen.dart';

// =========================
// STUDENT MAIN SCREENS
// =========================
import 'package:trial/screens/student/login_page.dart';
import 'package:trial/screens/student/dashboard/student_dashboard.dart';
import 'package:trial/screens/student/subject_detail_screen.dart';
import 'package:trial/screens/student/quiz_start_screen.dart';
import 'package:trial/screens/student/dashboard/tabs/profile_tab.dart'; // <--- 1. ADDED THIS IMPORT

// =========================
// STUDENT PAGES
// =========================
import 'package:trial/pages/student/class_list_page.dart';
import 'package:trial/pages/student/lessons_page.dart';
import 'package:trial/pages/student/lesson_viewer_page.dart';
import 'package:trial/pages/student/pomodoro_timer_page.dart';
import 'package:trial/pages/student/quiz_unlock_page.dart';
import 'package:trial/pages/quiz/quiz_questions_page.dart';
import 'package:trial/pages/student/student_profile_page.dart';
import 'package:trial/pages/student/leaderboard/leaderboard_page.dart';
import 'package:trial/pages/student/badges_page.dart';
import 'package:trial/pages/student/badge_details_page.dart';

import 'package:trial/models/lesson_model.dart';
import 'package:trial/models/leaderboard_entry.dart';
import 'package:trial/models/badge.dart' as badge_model;
import 'package:trial/models/quiz_model.dart';

// =========================
// TEACHER PAGES
// =========================
import 'package:trial/screens/teacher/login/teacher_login_page.dart';
import 'package:trial/screens/teacher/dashboard/teacher_dashboard.dart';
import 'package:trial/screens/teacher/classes/teacher_class_detail.dart';
import 'package:trial/screens/teacher/classes/teacher_student_detail.dart';
import 'package:trial/screens/teacher/monitoring/teacher_live_monitoring_page.dart';
import 'package:trial/screens/teacher/announcements/teacher_announcements_page.dart';
import 'package:trial/screens/teacher/announcements/teacher_announcement_view_page.dart';
import 'package:trial/screens/teacher/profile/teacher_profile_page.dart';
import 'package:trial/screens/teacher/profile/teacher_edit_profile_page.dart';
import 'package:trial/screens/teacher/quiz_creator_screen.dart';
import 'package:trial/screens/teacher/announcements/create_announcement_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {

      // =========================
      // PUBLIC
      // =========================
      case '/landing':
        page = const LandingPage();
        break;
  
      // =========================
      // AUTH
      // =========================
      case '/loginSelection':
        page = const LoginSelectionPage();
        break;

      case '/register':
        page = const RegisterPage();
        break;

      case '/simpleLogin':
        page = const SimpleLoginScreen();
        break;

      // =========================
      // STUDENT
      // =========================
      case '/studentLogin':
        page = const StudentLoginPage();
        break;

      case '/studentDashboard':
        page = const StudentDashboard();
        break;

      case '/subjectDetail':
        final subjectName = settings.arguments as String? ?? '';
        page = SubjectDetailScreen(subjectName: subjectName);
        break;

      case '/quizStart':
        final quiz = settings.arguments;
        if (quiz == null || quiz is! QuizModel) { 
          page = const LandingPage();
        } else {
          page = QuizStartScreen(quiz: quiz);
        }
        break;

      case '/classList':
        page = const ClassListPage();
        break;

      case '/lessons':
        final classId = settings.arguments as String? ?? '';
        page = LessonsPage(classId: classId);
        break;

      case '/lessonViewer':
        final lesson = settings.arguments;
        if (lesson == null || lesson is! LessonModel) {
          page = const LandingPage();
        } else {
          page = LessonViewerPage(lesson: lesson);
        }
        break;

      case '/pomodoro':
        page = const PomodoroTimerPage();
        break;

      case '/quizUnlock':
        page = const QuizUnlockPage();
        break;

      case '/quizQuestions':
        final quiz = settings.arguments;
        if (quiz == null || quiz is! QuizModel) {
          page = const QuizQuestionsPage();
        } else {
          page = QuizQuestionsPage(quiz: quiz);
        }
        break;

      case '/leaderboard':
        page = const LeaderboardPage();
        break;

      // --- 2. UPDATED STUDENT PROFILE ROUTE ---
      case '/studentProfile':
        final args = settings.arguments;
        // If arguments are provided (e.g. from Leaderboard), view that student
        if (args is LeaderboardEntry) {
          page = StudentProfilePage(student: args);
        } 
        // If no arguments (e.g. from Dashboard Menu), view MY Profile Tab
        else {
          page = const ProfileTab();
        }
        break;
      // ----------------------------------------

      case '/badges':
        page = const BadgesPage();
        break;

      case '/badgeDetails':
        final badge = settings.arguments;
        if (badge == null || badge is! badge_model.Badge) {
          page = const LandingPage();
        } else {
          page = BadgeDetailsPage(badge: badge);
        }
        break;

      // =========================
      // TEACHER
      // =========================
      case '/teacherLogin':
        page = const TeacherLoginPage();
        break;

      case '/teacherDashboard':
        page = const TeacherDashboardPage();
        break;

      case '/teacherClassDetail':
        page = const TeacherClassDetailPage();
        break;

      case '/teacherStudentDetail':
        final student = settings.arguments;
        if (student == null) {
          page = const TeacherStudentDetailPage();
        } else {
          page = TeacherStudentDetailPage();
        }
        break;

      case '/teacherLiveMonitoring':
        page = const TeacherLiveMonitoringPage();
        break;

      case '/teacherAnnouncements':
        page = const TeacherAnnouncementsPage();
        break;

      case '/createAnnouncement':
        page = const CreateAnnouncementScreen();
        break;

      case '/teacherAnnouncementView':
        page = const TeacherAnnouncementViewPage();
        break;

      case '/teacherProfile':
        page = const TeacherProfilePage();
        break;

      case '/teacherEditProfile':
        page = const TeacherEditProfilePage();
        break;

      case '/quizCreator':
        page = const QuizCreatorScreen();
        break;

      // =========================
      // DEFAULT
      // =========================
      default:
        page = const LandingPage();
    }

    // Smooth fade + slide transition
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0.05),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: page,
        ),
      ),
    );
  }
}