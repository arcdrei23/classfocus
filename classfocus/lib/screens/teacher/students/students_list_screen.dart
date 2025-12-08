// lib/screens/teacher/students/students_list_screen.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock students data - will be replaced with Firebase data
    final students = [
      {
        'id': '1',
        'name': 'John Doe',
        'studentId': 'ID 12345',
        'email': 'john.doe@college.edu',
        'grade': 'Grade 6',
        'class': 'Einstein',
        'xp': 850,
        'avatarUrl': null,
      },
      {
        'id': '2',
        'name': 'Maria Reyes',
        'studentId': 'ID 12346',
        'email': 'maria.reyes@college.edu',
        'grade': 'Grade 6',
        'class': 'Einstein',
        'xp': 920,
        'avatarUrl': null,
      },
      {
        'id': '3',
        'name': 'Alex Cruz',
        'studentId': 'ID 12347',
        'email': 'alex.cruz@college.edu',
        'grade': 'Grade 6',
        'class': 'Einstein',
        'xp': 780,
        'avatarUrl': null,
      },
      {
        'id': '4',
        'name': 'Sarah Johnson',
        'studentId': 'ID 12348',
        'email': 'sarah.johnson@college.edu',
        'grade': 'Grade 6',
        'class': 'Einstein',
        'xp': 1050,
        'avatarUrl': null,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('All Students'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return _buildStudentCard(context, student);
        },
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: InkWell(
        onTap: () {
          // Navigate to student detail - ready for Firebase integration
          Navigator.pushNamed(
            context,
            '/teacherStudentDetail',
            arguments: student,
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
              backgroundImage: student['avatarUrl'] != null
                  ? AssetImage(student['avatarUrl'] as String)
                  : null,
              child: student['avatarUrl'] == null
                  ? Text(
                      student['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['studentId'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.school, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${student['grade']} • ${student['class']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${student['xp']} XP',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

