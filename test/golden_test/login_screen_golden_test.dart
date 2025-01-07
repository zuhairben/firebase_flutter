import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:firebase_flutter/auth/login_screen.dart';

void main() async{
  await loadAppFonts();
  group('LoginScreen Golden Test', () {
    testGoldens('renders correctly', (WidgetTester tester) async {
      // Arrange: Create the widget to test
      final loginScreen = LoginScreen(
        login: (email, password) {},
        signup: () {},
      );

      // Act: Load the widget into the tester
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(body: loginScreen),
        ),
      );

      // Assert: Compare with the golden file
      await screenMatchesGolden(tester, 'login_screen');
    });
  });
}