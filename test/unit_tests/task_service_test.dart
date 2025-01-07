import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_flutter/auth/AuthService.dart'; // Replace with the correct path to AuthService

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    authService = AuthService();
  });

  group('AuthService', () {
    test('registration returns Success on successful registration', () async {
      // Mock return values
      when(mockAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('testUid'); // Non-null UID
      when(mockFirestore.collection(any)).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.set(any)).thenAnswer((_) async => {});

      final result = await authService.registration(
        email: 'test@example.com',
        password: 'password123',
        role: 'Admin',
      );

      expect(result, equals('Success'));
    });

    test('login returns Success on successful login', () async {
      when(mockAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authService.login(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, equals('Success'));
    });

    test('getUserRole returns role from Firestore', () async {
      final mockSnapshot = MockDocumentSnapshot();

      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('testUid'); // Non-null UID
      when(mockFirestore.collection(any)).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot['role']).thenReturn('Admin'); // Non-null role

      final result = await authService.getUserRole();

      expect(result, equals('Admin'));
    });

    test('getUserRole throws exception when user is not logged in', () {
      when(mockAuth.currentUser).thenReturn(null);

      expect(
            () => authService.getUserRole(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
