// lib/routes.dart
import 'package:flutter/material.dart';

// =========================
// AUTH SCREENS
// =========================
import 'screens/landing/landing_page.dart';
import 'screens/auth/login_selection_page.dart';
import 'screens/auth/register_page.dart';

// =========================
// STUDENT MAIN SCREENS
// =========================
import 'screens/student/login_page.dart';
import 'screens/student/dashboard/student_dashboard.dart';

// =========================
// STUDENT PAGES
// =========================
import 'pages/student/class_list_page.dart';
import 'pages/student/lessons_page.dart';
import 'pages/student/lesson_viewer_page.dart';
import 'pages/student/pomodoro_timer_page.dart';
import 'pages/student/quiz_unlock_page.dart';
import 'pages/student/quiz_questions_page.dart';
import 'pages/student/student_profile_page.dart';
import 'pages/student/badges_page.dart';
import 'pages/student/badge_details_page.dart';
import 'pages/student/leaderboard/leaderboard_page.dart';
import 'models/lesson_model.dart';
import 'models/leaderboard_entry.dart';
import 'models/badge.dart' as models;

// =========================
// TEACHER PAGES
// =========================
import 'screens/teacher/login/teacher_login_page.dart';
import 'screens/teacher/dashboard/teacher_dashboard.dart';
// import 'screens/teacher/classes/teacher_class_list.dart'; // TODO: Create this file
import 'screens/teacher/classes/teacher_class_detail.dart';
import 'screens/teacher/classes/teacher_student_detail.dart';
// import 'screens/teacher/lessons/lesson_upload_page.dart'; // TODO: Create this file
// import 'screens/teacher/quiz/quiz_builder_page.dart'; // TODO: Create this file
import 'screens/teacher/monitoring/teacher_live_monitoring_page.dart';
// import 'screens/teacher/leaderboard/teacher_leaderboard_page.dart'; // TODO: Create this file
// import 'screens/teacher/analytics/teacher_analytics_page.dart'; // TODO: Create this file
import 'screens/teacher/announcements/teacher_announcements_page.dart';
import 'screens/teacher/announcements/teacher_announcement_view_page.dart';
import 'screens/teacher/profile/teacher_profile_page.dart';
import 'screens/teacher/profile/teacher_edit_profile_page.dart';

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

      // =========================
      // STUDENT
      // =========================
      case '/studentLogin':
        page = const StudentLoginPage();
        break;

      case '/studentDashboard':
        page = const StudentDashboard();
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
        page = const QuizQuestionsPage();
        break;

      case '/studentProfile':
        final student = settings.arguments;
        if (student == null || student is! LeaderboardEntry) {
          page = const LandingPage();
        } else {
          page = StudentProfilePage(student: student);
        }
        break;

      case '/badges':
        page = const BadgesPage();
        break;

      case '/badgeDetails':
        final badge = settings.arguments;
        if (badge == null || badge is! models.Badge) {
          page = const LandingPage();
        } else {
          page = BadgeDetailsPage(badge: badge);
        }
        break;

      case '/leaderboard':
        page = const LeaderboardPage();
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

      // case '/teacherClassList':
      //   page = const TeacherClassListPage();
      //   break;

      case '/teacherClassDetail':
        page = const TeacherClassDetailPage();
        break;

      case '/teacherStudentDetail':
        page = const TeacherStudentDetailPage();
        break;

      // case '/teacherUploadLesson':
      //   page = const LessonUploadPage();
      //   break;

      // case '/teacherQuizBuilder':
      //   page = const QuizBuilderPage();
      //   break;

      case '/teacherLiveMonitoring':
        page = const TeacherLiveMonitoringPage();
        break;

      // case '/teacherLeaderboard':
      //   page = const TeacherLeaderboardPage();
      //   break;

      // case '/teacherAnalytics':
      //   page = const TeacherAnalyticsPage();
      //   break;

      case '/teacherAnnouncements':
        page = const TeacherAnnouncementsPage();
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
