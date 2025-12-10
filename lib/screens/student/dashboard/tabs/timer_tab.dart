// lib/screens/student/dashboard/tabs/timer_tab.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> with WidgetsBindingObserver {
  Timer? _timer;
  int _totalSeconds = 25 * 60; // 25 minutes in seconds
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  String _currentMode = 'pomodoro'; // 'pomodoro', 'short break', 'long break'
  bool _wasInterrupted = false;

  // Mode durations in seconds
  final Map<String, int> _modeDurations = {
    'pomodoro': 25 * 60,      // 25 minutes
    'short break': 5 * 60,    // 5 minutes
    'long break': 15 * 60,    // 15 minutes
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = _modeDurations[_currentMode]!;
    _totalSeconds = _modeDurations[_currentMode]!;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((_isRunning) &&
        (state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused)) {
      _pauseTimer();
      _wasInterrupted = true;
      SystemSound.play(SystemSoundType.alert);
    } else if (_wasInterrupted && state == AppLifecycleState.resumed) {
      _wasInterrupted = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer paused due to switching apps'),
        ),
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  void _startTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _pauseTimer();
          SystemSound.play(SystemSoundType.alert);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time is up!')),
          );
        }
      });
    }
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
  }

  void _switchMode(String mode) {
    if (_currentMode != mode) {
      _pauseTimer();
      setState(() {
        _currentMode = mode;
        _remainingSeconds = _modeDurations[mode]!;
        _totalSeconds = _modeDurations[mode]!;
      });
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get _progress => _totalSeconds > 0 ? (_remainingSeconds / _totalSeconds) : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Deep Midnight Blue
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'pomodoro',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Mode Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44), // Container background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildModeButton('pomodoro'),
                    _buildModeButton('short break'),
                    _buildModeButton('long break'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Main Timer Circle
            GestureDetector(
              onTap: _startTimer,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7575).withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2D2D44),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF7575), // Coral Pink
                        ),
                      ),
                    ),
                    // Center content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isRunning ? 'P A U S E' : 'S T A R T',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 4.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Settings Icon
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 28,
                ),
                onPressed: () {
                  // TODO: Open settings dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2D2D44),
                      title: const Text(
                        'Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Timer settings coming soon!',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Color(0xFFFF7575)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String mode) {
    final isSelected = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7575) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            mode,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
