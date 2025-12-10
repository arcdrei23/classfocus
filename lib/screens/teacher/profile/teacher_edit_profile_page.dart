import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class TeacherEditProfilePage extends StatefulWidget {
  final String? initialName;
  final String? initialTitle;
  final String? initialImageUrl;

  const TeacherEditProfilePage({
    super.key,
    this.initialName,
    this.initialTitle,
    this.initialImageUrl,
  });

  @override
  State<TeacherEditProfilePage> createState() => _TeacherEditProfilePageState();
}

class _TeacherEditProfilePageState extends State<TeacherEditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _imageCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _imageCtrl = TextEditingController(text: widget.initialImageUrl ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _avatarPreview(),
            const SizedBox(height: 24),
            _textField(_nameCtrl, 'Full Name', Icons.person),
            const SizedBox(height: 16),
            _textField(_titleCtrl, 'Title / Role', Icons.badge),
            const SizedBox(height: 16),
            _textField(_imageCtrl, 'Image URL', Icons.image),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameCtrl.text.trim(),
                    'title': _titleCtrl.text.trim(),
                    'imageUrl': _imageCtrl.text.trim(),
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.secondaryText),
        prefixIcon: Icon(icon, color: AppTheme.secondaryText),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _avatarPreview() {
    final url = _imageCtrl.text.trim();
    ImageProvider provider;
    if (url.isNotEmpty) {
      provider = NetworkImage(url);
    } else {
      provider = const AssetImage('assets/images/logo.png');
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: provider,
        ),
        const SizedBox(height: 8),
        const Text(
          'Paste an image URL to update your photo',
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
