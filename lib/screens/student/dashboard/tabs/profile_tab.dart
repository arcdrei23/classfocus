// lib/screens/student/dashboard/tabs/profile_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const SizedBox(height: 30),

          const CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage("assets/avatar.png"),
          ),

          const SizedBox(height: 20),

          const Text("Student Name",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("Grade 6",
              style: TextStyle(color: Colors.grey, fontSize: 16)),

          const SizedBox(height: 40),

          _profileButton(
              label: "Badges", onTap: () => Navigator.pushNamed(context, "/badges")),
          const SizedBox(height: 16),

          _profileButton(
              label: "Logout",
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/",
                    (route) => false,
                  )),
        ],
      ),
    );
  }

  Widget _profileButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.violet]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
