import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_flutter/auth/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {},
            signup: () {},
          ),
        ),
      );

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Login to continue'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
      expect(find.byType(ElevatedButton), findsOneWidget); // Login button
      expect(find.text("Don't have an account? Sign Up"), findsOneWidget);
    });

    testWidgets('Password visibility toggles on button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {},
            signup: () {},
          ),
        ),
      );

      final passwordField = find.byType(TextField).last; // Password TextField
      final toggleButton = find.byIcon(Icons.visibility_off);

      expect(toggleButton, findsOneWidget);

      await tester.tap(toggleButton);
      await tester.pump();

      // Check if icon changed to "visibility"
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Login button triggers login callback', (WidgetTester tester) async {
      bool loginCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {
              loginCalled = true;
              expect(email, "test@example.com");
              expect(password, "password123");
            },
            signup: () {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, "test@example.com");
      await tester.enterText(find.byType(TextField).last, "password123");

      await tester.tap(find.text("Login"));
      await tester.pump();

      expect(loginCalled, isTrue);
    });

    testWidgets('Sign Up button triggers signup callback', (WidgetTester tester) async {
      bool signupCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {},
            signup: () {
              signupCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pump();

      expect(signupCalled, isTrue);
    });
  });
}
