import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';

void main() async{
  await loadAppFonts();
  group('SignUpScreen Golden Test', () {
    testGoldens('renders correctly', (WidgetTester tester) async {
      // Arrange: Create the widget to test
      final signUpScreen = SignupScreen(
        login: () {},
        signup: (email, password, role) {},
      );

      // Act: Load the widget into the tester
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(body: signUpScreen),
        ),
      );

      // Assert: Compare with the golden file
      await screenMatchesGolden(tester, 'signup_screen');
    });
  });
}