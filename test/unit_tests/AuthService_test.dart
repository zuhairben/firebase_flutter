import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_flutter/auth/AuthService.dart'; // Update the path as needed

// Create a mock class for FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Create a mock class for UserCredential
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService();
  });

  test('User can log in successfully', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';
    final mockUserCredential = MockUserCredential();

    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).thenAnswer((_) async => mockUserCredential);

    // Act
    final result = await authService.login(email: email, password: password);

    // Assert
    expect(result, "Success");
    verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).called(1);
  });

  test('Login fails with an error', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';

    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).thenThrow(FirebaseAuthException(
      code: 'user-not-found',
      message: 'No user found for that email.',
    ));

    // Act
    final result = await authService.login(email: email, password: password);

    // Assert
    expect(result, contains('No user found for that email.'));
    verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).called(1);
  });
}
