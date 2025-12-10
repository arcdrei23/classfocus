// lib/screens/teacher/dashboard/teacher_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../students/students_list_screen.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _DashboardHomeTab(),
    const StudentsListScreen(),
    const _ReportsTab(), // Weekly Reports
    const _SettingsTab(), // Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Students"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}

// Dashboard Home Tab Content
class _DashboardHomeTab extends StatelessWidget {
  const _DashboardHomeTab();

  @override
  Widget build(BuildContext context) {
    // Demo data for students, classes, and quizzes
    final students = [
      {'name': 'Alex Cruz', 'id': 'STU-1023', 'progress': '92%', 'status': 'Active'},
      {'name': 'Janine Reyes', 'id': 'STU-1044', 'progress': '88%', 'status': 'Active'},
      {'name': 'Miguel Torres', 'id': 'STU-0991', 'progress': '74%', 'status': 'Needs help'},
    ];

    final classInfo = {
      'name': 'Grade 6 - Einstein',
      'subjects': 'Math, Science, English',
      'students': '32 students',
      'schedule': 'Mon-Fri • 8:00 AM - 3:00 PM',
      'room': 'Room 204'
    };

    final quizzes = [
      {
        'title': 'Math Quiz 3',
        'participants': ['Alex', 'Maria', 'John'],
        'count': 18,
        'status': 'Open'
      },
      {
        'title': 'Science Quiz 1',
        'participants': ['Janine', 'Kyle', 'Rina'],
        'count': 22,
        'status': 'Closed'
      },
    ];
    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // --- Improved Teacher Header ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, Color(0xFF8A4FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello, Mr. Anderson",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Teacher • Grade 6 Head",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    child: Icon(Icons.person, color: AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Quick Actions Banner (Improved Design) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
                          "Manage Class Content",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create quizzes or post announcements.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _actionBtn(context, "Quiz", Icons.add_task),
                            const SizedBox(width: 12),
                            _actionBtn(context, "Post", Icons.campaign),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.dashboard_customize,
                    color: Colors.white.withOpacity(0.2),
                    size: 100,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Statistics Cards ---
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Total Students',
                    '127',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Active Quizzes',
                    '8',
                    Icons.quiz,
                    Colors.green,
                  ),
                ),
              ],
            ),

              const SizedBox(height: 24),
              
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Announcements',
                    '12',
                    Icons.campaign,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'Avg. Score',
                    '85%',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- Class Details ---
            const Text(
              "Class Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _classDetailCard(classInfo),

              const SizedBox(height: 24),
              
            // --- Students Details ---
            const Text(
              "Student Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...students.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _studentDetailTile(s),
                )),

              const SizedBox(height: 24),

            // --- My Quizzes (with participants) ---
            const Text(
              "My Quizzes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...quizzes.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _quizTile(context, q),
                )),

              const SizedBox(height: 24),

            // --- My Classes Grid (Improved) ---
            const Text(
              "My Classes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            children: [
                _classCard("Math 6", "32 Students", Colors.blue, Icons.calculate),
                _classCard("Science 6", "30 Students", Colors.green, Icons.science),
                _classCard("Advisory", "32 Students", Colors.orange, Icons.people),
                _classCard("Club", "15 Members", Colors.purple, Icons.star),
              ],
            ),

            const SizedBox(height: 30),

            // --- Recent Submissions (Improved) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
                  "Recent Submissions",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full submissions view
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(color: AppTheme.primaryBlue),
          ),
        ),
      ],
        ),
        const SizedBox(height: 16),
            _submissionItem("Alex Cruz", "Math Quiz 3", "95%", true),
            _submissionItem("Maria Reyes", "Science Quiz 1", "40%", false),
            _submissionItem("John Doe", "English Quiz 2", "88%", true),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(BuildContext context, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Quiz') {
          Navigator.pushNamed(context, '/quizCreator');
        } else if (label == 'Post') {
          Navigator.pushNamed(context, '/teacherAnnouncements');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
          child: Row(
          mainAxisSize: MainAxisSize.min,
            children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
          ),
        ),
      ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _classDetailCard(Map<String, String> info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
              const Icon(Icons.class_, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                info['name'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _classRow(Icons.book, info['subjects'] ?? ''),
          _classRow(Icons.people, info['students'] ?? ''),
          _classRow(Icons.schedule, info['schedule'] ?? ''),
          _classRow(Icons.room, info['room'] ?? ''),
        ],
      ),
    );
  }

  Widget _classRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
          Icon(icon, color: Colors.grey[600], size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
                    ),
                  ),
                ],
      ),
    );
  }

  Widget _studentDetailTile(Map<String, String> student) {
    final status = student['status'] ?? '';
    final statusColor =
        status.toLowerCase().contains('need') ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.15),
            child: Text(
              student['name']?.substring(0, 1) ?? '?',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  student['id'] ?? '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                student['progress'] ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                ),
            ),
          ],
        ),
        ],
      ),
    );
  }

  Widget _quizTile(BuildContext context, Map<String, Object?> quiz) {
    final participants = (quiz['participants'] as List<String>? ?? []);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quiz['title'] as String? ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${quiz['count'] ?? 0} joined",
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: participants
                .map(
                  (p) => Chip(
                    label: Text(p),
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryBlue),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          Text(
            "Status: ${quiz['status'] ?? 'Open'}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showParticipantsDialog(context, participants),
              icon: const Icon(Icons.people_outline),
              label: const Text('View participants'),
            ),
          ),
        ],
      ),
    );
  }

  void _showParticipantsDialog(BuildContext context, List<String> participants) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Participants'),
        content: participants.isEmpty
            ? const Text('No participants yet.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: participants
                    .map((p) => ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(p),
                        ))
                    .toList(),
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

  Widget _classCard(String title, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[400], size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _submissionItem(String student, String quiz, String score, bool isPassing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            child: Text(
              student[0],
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Submitted: $quiz",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
              color: isPassing
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isPassing ? Colors.green : Colors.red,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// Reports Tab - Weekly Report UI
class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    // Get current week dates
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final startDate = '${startOfWeek.day.toString().padLeft(2, '0')} ${_getMonthName(startOfWeek.month)}';
    final endDate = '${endOfWeek.day.toString().padLeft(2, '0')} ${_getMonthName(endOfWeek.month)} ${endOfWeek.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Weekly Report",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            // Date Range Header
            Text(
              "$startDate - $endDate",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Summary Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryStat("20", "Classes", Colors.green),
                _summaryStat("19.2", "Hours", Colors.blue),
                _summaryStat("127", "Students", Colors.orange),
              ],
            ),
            const SizedBox(height: 32),

            // Class Activities List
            _classActivityItem(
              context,
              "Mathematics",
              Icons.calculate,
              Colors.red,
              "6.1 hours",
              "8 Sessions",
              "32 Students",
        ),
        const SizedBox(height: 16),
            _classActivityItem(
              context,
              "Science",
              Icons.science,
              Colors.lightBlue,
              "3.1 hours",
              "4 Sessions",
              "30 Students",
            ),
            const SizedBox(height: 16),
            _classActivityItem(
              context,
              "English",
              Icons.menu_book,
              Colors.purple,
              "2 hours",
              "2 Sessions",
              "28 Students",
            ),
            const SizedBox(height: 16),
            _classActivityItem(
              context,
              "History",
              Icons.history_edu,
              Colors.pink,
              "8 hours",
              "6 Sessions",
              "25 Students",
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _summaryStat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _classActivityItem(
    BuildContext context,
    String className,
    IconData icon,
    Color color,
    String hours,
    String sessions,
    String students,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  className,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      hours,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      sessions,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      students,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // View Details Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/teacherClassDetail');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              "View Details",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Tab
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mr. Anderson",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                const SizedBox(height: 4),
                        Text(
                          "Teacher • Grade 6 Head",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
              ],
            ),
          ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/teacherEditProfile');
                    },
                    icon: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Account Settings
            _settingsSection(
              context,
              "Account",
              [
                _settingsTile(
                  context,
                  Icons.person_outline,
                  "Edit Profile",
                  () => Navigator.pushNamed(context, '/teacherEditProfile'),
                ),
                _settingsTile(
                  context,
                  Icons.lock_outline,
                  "Change Password",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change Password feature coming soon')),
                    );
                  },
                ),
                _settingsTile(
                  context,
                  Icons.email_outlined,
                  "Email Settings",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email Settings feature coming soon')),
                    );
                  },
                ),
              ],
            ),

            // Notifications
            _settingsSection(
              context,
              "Notifications",
              [
                _switchTile(
                  context,
                  Icons.notifications_outlined,
                  "Push Notifications",
                  true,
                  (value) {},
                ),
                _switchTile(
                  context,
                  Icons.email,
                  "Email Notifications",
                  true,
                  (value) {},
                ),
                _switchTile(
                  context,
                  Icons.assignment,
                  "Assignment Alerts",
                  true,
                  (value) {},
                ),
                _switchTile(
                  context,
                  Icons.quiz,
                  "Quiz Reminders",
                  false,
                  (value) {},
                ),
              ],
            ),

            // Class Settings
            _settingsSection(
              context,
              "Class Settings",
              [
                _settingsTile(
                  context,
                  Icons.class_outlined,
                  "Manage Classes",
                  () => Navigator.pushNamed(context, '/teacherClassDetail'),
                ),
                _settingsTile(
                  context,
                  Icons.calendar_today,
                  "Class Schedule",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Class Schedule feature coming soon')),
                    );
                  },
                ),
                _settingsTile(
                  context,
                  Icons.grade,
                  "Grading Preferences",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Grading Preferences feature coming soon')),
                    );
                  },
                ),
              ],
            ),

            // Privacy & Security
            _settingsSection(
              context,
              "Privacy & Security",
              [
                _settingsTile(
                  context,
                  Icons.privacy_tip_outlined,
                  "Privacy Policy",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy')),
                    );
                  },
                ),
                _settingsTile(
                  context,
                  Icons.security,
                  "Security Settings",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Security Settings feature coming soon')),
                    );
                  },
                ),
                _switchTile(
                  context,
                  Icons.visibility_outlined,
                  "Show Profile to Students",
                  true,
                  (value) {},
                ),
              ],
            ),

            // Support
            _settingsSection(
              context,
              "Support",
              [
                _settingsTile(
                  context,
                  Icons.help_outline,
                  "Help Center",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help Center')),
                    );
                  },
                ),
                _settingsTile(
                  context,
                  Icons.feedback_outlined,
                  "Send Feedback",
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Send Feedback')),
                    );
                  },
                ),
                _settingsTile(
                  context,
                  Icons.info_outline,
                  "About",
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("About ClassFocus"),
                        content: const Text("Version 1.0.0\n\nClassFocus - Educational Management System"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<AuthService>(
                builder: (context, authService, child) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                authService.logout();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/loginSelection',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _settingsSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _switchTile(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryBlue,
      ),
    );
  }
}
