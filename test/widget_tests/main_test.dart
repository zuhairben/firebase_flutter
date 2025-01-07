import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_flutter/main.dart';

void main() {
  testWidgets('App renders HomeScreen as initial route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("Welcome Back!"), findsOneWidget);
    expect(find.text("Login to continue"), findsOneWidget);
  });

  testWidgets('Navigates to Signup screen on tapping Sign Up', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pumpAndSettle();

    expect(find.text("Create an Account"), findsOneWidget); // Adjust text as per your Signup screen UI
  });
}
