import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';

class MockSignup extends Mock {
  void call(String email, String password, String role);
}

class MockLogin extends Mock {
  void call();
}

void main() {
  testWidgets('SignupScreen test', (WidgetTester tester) async {
    final mockSignup = MockSignup();
    final mockLogin = MockLogin();

    await tester.pumpWidget(
      MaterialApp(
        home: SignupScreen(
          signup: mockSignup.call,
          login: mockLogin.call,
        ),
      ),
    );

    // Test widget rendering
    expect(find.text('Create an Account'), findsOneWidget);
  });
}
