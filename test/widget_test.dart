import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formative_assignment_1/main.dart';

void main() {
  testWidgets('App loads and handles navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudentApp());

    // Verify that the Dashboard is displayed by default.
    expect(find.text('Dashboard'), findsOneWidget);

    // Verify Bottom Navigation Items exist
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.assignment), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
  });
}
