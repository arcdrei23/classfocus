import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your app files
import 'package:trial/screens/student/dashboard/tabs/home_dashboard_tab.dart'; 
import 'package:trial/theme/app_theme.dart';

void main() {
  testWidgets('HomeDashboardTab loads correctly', (WidgetTester tester) async {
    // 1. Wrap the widget in MaterialApp
    // We also provide the Theme so colors render correctly in the test environment
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const HomeDashboardTab(),
      ),
    );

    // 2. Allow animations to settle (helper for image loading issues)
    await tester.pumpAndSettle();

    // 3. Verify the "Subjects" section exists
    expect(find.text('Subjects'), findsOneWidget);

    // 4. Verify the "Recent Activity" section exists
    expect(find.text('Recent Activity'), findsOneWidget);

    // 5. Verify that the old counter text "0" does NOT exist
    expect(find.text('0'), findsNothing);
  });
}