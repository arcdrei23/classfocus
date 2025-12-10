// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 1. Import the specific file where the tab is defined
import 'package:trial/screens/student/dashboard/tabs/home_dashboard_tab.dart'; 

void main() {
  testWidgets('HomeDashboardTab loads correctly', (WidgetTester tester) async {
    // 2. Wrap the widget in MaterialApp so Scaffold works
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeDashboardTab(),
      ),
    );

    // 3. Update expectations to match what is actually on your Dashboard
    // We expect to see "Subjects" and the user greeting.
    expect(find.text('Subjects'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);

    // Verify that the counter text "0" does NOT exist
    expect(find.text('0'), findsNothing);
  });
}