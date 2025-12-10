import 'package:flutter/material.dart';
import 'teacher_edit_profile_page.dart';
import '../../../theme/app_theme.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  String name = 'Mr. Anderson';
  String title = 'Teacher • Grade 6 Head';
  String imageUrl = 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeacherEditProfilePage(
                    initialName: name,
                    initialTitle: title,
                    initialImageUrl: imageUrl,
                  ),
                ),
              );
              if (result is Map<String, String>) {
                setState(() {
                  name = result['name'] ?? name;
                  title = result['title'] ?? title;
                  imageUrl = result['imageUrl'] ?? imageUrl;
                });
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _infoTile(Icons.email, 'Email', 'teacher@classfocus.edu'),
            const SizedBox(height: 12),
            _infoTile(Icons.phone, 'Phone', '+1 555-123-4567'),
            const SizedBox(height: 12),
            _infoTile(Icons.class_, 'Classes', 'Grade 6 - Einstein, Curie'),
            const SizedBox(height: 12),
            _infoTile(Icons.badge, 'ID', 'TCHR-9921'),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
