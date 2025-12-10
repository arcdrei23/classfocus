// lib/screens/student/dashboard/tabs/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_theme.dart';
import '../../../../services/auth_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isEditing = false;
  final TextEditingController _emailController =
      TextEditingController(text: 'student.demo@gmail.com');
  final TextEditingController _classController =
      TextEditingController(text: 'Einstein');
  final TextEditingController _gradeController =
      TextEditingController(text: 'Grade 6');
  final TextEditingController _avatarController =
      TextEditingController(text: 'https://i.pravatar.cc/150?img=3');

  @override
  void dispose() {
    _emailController.dispose();
    _classController.dispose();
    _gradeController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        var user = authService.currentUser;

        // Auto-login with a default profile to keep the UI populated
        if (user == null) {
          authService.login('John Doe');
          user = authService.currentUser;
        }
        if (user == null) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        _emailController.text = user.email.isNotEmpty
            ? user.email
            : _emailController.text;
        _avatarController.text =
            user.profileImageUrl.isNotEmpty ? user.profileImageUrl : _avatarController.text;
        _classController.text = 'Einstein';
        _gradeController.text = 'Grade 6';

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Header with Avatar and edit toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildProfileHeader(context, user)),
                      IconButton(
                        icon: Icon(
                          _isEditing ? Icons.check_circle : Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => _isEditing = !_isEditing);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isEditing
                                  ? 'Editing enabled'
                                  : 'Editing saved'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'XP',
                          '${_formatNumber(user.xp)}',
                          Icons.star_rounded,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Streak',
                          '${user.streak} days',
                          Icons.local_fire_department,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: _emailController.text,
                    isEditing: _isEditing,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.image_outlined,
                    label: 'Avatar URL',
                    value: _avatarController.text,
                    isEditing: _isEditing,
                    controller: _avatarController,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.badge_outlined,
                    label: 'Student ID',
                    value: user.studentId,
                    isEditing: false,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.school_outlined,
                    label: 'Grade',
                    value: _gradeController.text,
                    isEditing: _isEditing,
                    controller: _gradeController,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.class_outlined,
                    label: 'Class',
                    value: _classController.text,
                    isEditing: _isEditing,
                    controller: _classController,
                  ),
                  const SizedBox(height: 32),

                  // Level/Progress Section
                  _buildLevelCard(user),
                  const SizedBox(height: 32),

                  // Recent Activity Section
                  _buildSectionTitle('Recent Activity'),
                  const SizedBox(height: 16),
                  if (user.recentActivities.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'No recent activity',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    ...user.recentActivities.take(3).map((activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildActivityCard(activity),
                    )),
                  const SizedBox(height: 32),

                  // Achievements Section
                  _buildSectionTitle('Achievements'),
                  const SizedBox(height: 16),
                  _profileButton(
                    label: "View All Badges",
                    icon: Icons.emoji_events,
                    onTap: () => Navigator.pushNamed(context, "/badges"),
                  ),
                  const SizedBox(height: 20),
                  // Badge Preview Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBadgePreview('Quiz Master', Icons.quiz, Colors.blue),
                      _buildBadgePreview('Perfect Score', Icons.star, Colors.amber),
                      _buildBadgePreview('Early Bird', Icons.alarm, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Settings Section - Comprehensive UI
                  _buildSectionTitle('Settings'),
                  const SizedBox(height: 16),
                  
                  // Account Settings
                  _buildSettingsSection(
                    context,
                    'Account',
                    [
                      _buildSettingsTile(
                        context,
                        Icons.edit_outlined,
                        'Edit Profile',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit Profile feature coming soon')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.lock_outlined,
                        'Change Password',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Change Password feature coming soon')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.email_outlined,
                        'Email Settings',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email Settings feature coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notifications
                  _buildSettingsSection(
                    context,
                    'Notifications',
                    [
                      _buildSwitchTile(
                        context,
                        Icons.notifications_outlined,
                        'Push Notifications',
                        true,
                        (value) {},
                      ),
                      _buildSwitchTile(
                        context,
                        Icons.email,
                        'Email Notifications',
                        true,
                        (value) {},
                      ),
                      _buildSwitchTile(
                        context,
                        Icons.assignment,
                        'Assignment Alerts',
                        true,
                        (value) {},
                      ),
                      _buildSwitchTile(
                        context,
                        Icons.quiz,
                        'Quiz Reminders',
                        false,
                        (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // App Preferences
                  _buildSettingsSection(
                    context,
                    'App Preferences',
                    [
                      _buildSwitchTile(
                        context,
                        Icons.dark_mode_outlined,
                        'Dark Mode',
                        true,
                        (value) {},
                      ),
                      _buildSwitchTile(
                        context,
                        Icons.language,
                        'Language',
                        false,
                        (value) {},
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.storage_outlined,
                        'Storage & Data',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Storage & Data settings')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Privacy & Security
                  _buildSettingsSection(
                    context,
                    'Privacy & Security',
                    [
                      _buildSettingsTile(
                        context,
                        Icons.privacy_tip_outlined,
                        'Privacy Policy',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy Policy')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.security,
                        'Security Settings',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Security Settings feature coming soon')),
                          );
                        },
                      ),
                      _buildSwitchTile(
                        context,
                        Icons.visibility_outlined,
                        'Show Profile to Others',
                        true,
                        (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Support
                  _buildSettingsSection(
                    context,
                    'Support',
                    [
                      _buildSettingsTile(
                        context,
                        Icons.help_outline,
                        'Help Center',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Help Center')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.feedback_outlined,
                        'Send Feedback',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Send Feedback')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        Icons.info_outline,
                        'About',
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
                  const SizedBox(height: 32),

                  // Logout Button
                  _profileButton(
                    label: "Logout",
                    icon: Icons.logout,
                    onTap: () {
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
                                  "/loginSelection",
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
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    final numberStr = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < numberStr.length; i++) {
      if (i > 0 && (numberStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(numberStr[i]);
    }
    return buffer.toString();
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppTheme.surface,
              backgroundImage: _resolveAvatarProvider(_avatarController.text),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.background, width: 3),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.studentId,
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
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
            style: const TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool isEditing = false,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
                if (isEditing && controller != null)
                  TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.secondaryText),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryBlue),
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: child,
        )),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(user) {
    // Calculate level based on XP (e.g., 100 XP per level)
    final level = (user.xp / 100).floor() + 1;
    final xpForCurrentLevel = user.xp % 100;
    final xpForNextLevel = 100;
    final progress = xpForCurrentLevel / xpForNextLevel;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withOpacity(0.3),
            const Color(0xFF8A4FFF).withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '${_formatNumber(user.xp)} XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level ${level + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$xpForCurrentLevel / $xpForNextLevel XP',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppTheme.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(activity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.subjectName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.topic,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
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
                  color: _getScoreColor(activity.score).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activity.score,
                  style: TextStyle(
                    color: _getScoreColor(activity.score),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.timeAgo,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(String score) {
    // Extract numeric score from "85/100" format
    final parts = score.split('/');
    if (parts.length == 2) {
      final obtained = int.tryParse(parts[0]) ?? 0;
      final total = int.tryParse(parts[1]) ?? 100;
      final percentage = obtained / total;
      
      if (percentage >= 0.9) return Colors.green;
      if (percentage >= 0.7) return Colors.orange;
      return Colors.red;
    }
    return Colors.grey;
  }

  Widget _buildBadgePreview(String name, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _profileButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppTheme.primaryBlue,
              Color(0xFF8A4FFF),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _resolveAvatarProvider(String value) {
    if (value.startsWith('http')) {
      return NetworkImage(value);
    }
    return AssetImage(value);
  }
}
