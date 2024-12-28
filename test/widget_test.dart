import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_flutter/main.dart'; // Replace with your actual project name or file path

void main() {
  group('UI Tests for Weekly Expense', () {
    testWidgets('Verify presence of Weekly Expense title and View Report button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Weekly Expense'), findsOneWidget);
      expect(find.text('View Report'), findsOneWidget);
    });

    testWidgets('Verify presence of percentage bubbles and legend items', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('48%'), findsOneWidget);
      expect(find.text('32%'), findsOneWidget);
      expect(find.text('13%'), findsOneWidget);
      expect(find.text('7%'), findsOneWidget);

      expect(find.text('Grocery'), findsOneWidget);
      expect(find.text('Food & Drink'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Transportation'), findsOneWidget);
    });

    testWidgets('Verify presence of amounts for legend items', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('\$758.20'), findsNWidgets(4));
    });
  });
}
