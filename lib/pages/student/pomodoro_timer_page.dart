import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/timer_painter.dart';
import 'quiz_unlock_page.dart';

class PomodoroTimerPage extends StatefulWidget {
  const PomodoroTimerPage({super.key});

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage>
    with TickerProviderStateMixin {
  static const int maxSeconds = 1500; // 25 minutes
  int remainingSeconds = maxSeconds;

  AnimationController? _controller;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: maxSeconds),
    );
  }

  void startTimer() {
    setState(() => isRunning = true);

    _controller!.reverse(
      from: _controller!.value == 0 ? 1 : _controller!.value,
    );

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (remainingSeconds > 0 && isRunning) {
          remainingSeconds--;
        } else {
          timer.cancel();
          isRunning = false;

          // when finished → Unlock quiz
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const QuizUnlockPage()),
          );
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
      remainingSeconds = maxSeconds;
      _controller!.reset();
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Focus Timer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer circle
            SizedBox(
              height: size.width * 0.7,
              width: size.width * 0.7,
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  return CustomPaint(
                    painter: TimerPainter(
                      animation: _controller!,
                      backgroundColor: Colors.white12,
                      color: Colors.purpleAccent,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTapDown: (_) {},
              onTapUp: (_) {},
              onTap: () {
                if (isRunning) {
                  stopTimer();
                } else {
                  startTimer();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      isRunning
                          ? Colors.redAccent
                          : Colors.purpleAccent.shade200,
                      isRunning ? Colors.deepOrange : Colors.blueAccent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      blurRadius: 14,
                    )
                  ],
                ),
                child: Text(
                  isRunning ? "STOP" : "START",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
