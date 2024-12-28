import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:firebase_flutter/main.dart'; // Replace with your actual project name or file path

void main() {
  testGoldens('Golden Test for Weekly Expense Screen', (WidgetTester tester) async {
    // Load your widget
    await tester.pumpWidgetBuilder(
      const MyApp()
    );

    // Take a screenshot and compare it to the golden file
    await screenMatchesGolden(tester, 'ui_sc');
  });
}
