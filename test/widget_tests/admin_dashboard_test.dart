import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/dashboard/admin_dashboard.dart';
import 'package:firebase_flutter/pages/manage_tasks_page.dart';
import 'package:firebase_flutter/pages/manage_users_page.dart';
import 'package:firebase_flutter/pages/team_activity_page.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockFirestore extends Mock implements FirebaseFirestore {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirestore mockFirestore;
  late MockUser mockUser;
  late MockDocumentSnapshot mockDocumentSnapshot;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirestore();
    mockUser = MockUser();
    mockDocumentSnapshot = MockDocumentSnapshot();

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('mockUid');
    when(() => mockFirestore.collection('users').doc('mockUid').get())
        .thenAnswer((_) async => mockDocumentSnapshot);
    when(() => mockDocumentSnapshot['role']).thenReturn('Admin');
    when(() => mockDocumentSnapshot.exists).thenReturn(true); // Ensure the document exists
    when(() => mockDocumentSnapshot.data()).thenReturn({'role': 'Admin'}); // Mock data method
  });

  testWidgets('Admin Dashboard displays correct information', (WidgetTester tester) async {
    // Build the widget tree with the mocks
    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboard(),
      ),
    );

    // Wait for Firebase data to be fetched
    await tester.pumpAndSettle();

    // Verify the app bar title
    expect(find.text('Admin Dashboard'), findsOneWidget);

    // Verify the role and email in the drawer (using defaults if role/email is null)
    expect(find.text('Admin'), findsOneWidget); // Role is mocked as 'Admin'
    expect(find.text('admin@example.com'), findsOneWidget); // Default email

    // Verify that the "Manage Tasks" tab is displayed (default page)
    expect(find.byType(ManageTasksPage), findsOneWidget);

    // Tap on the "Manage Users" tab in the drawer
    await tester.tap(find.text('Manage Users'));
    await tester.pumpAndSettle();

    // Verify that "Manage Users" page is displayed
    expect(find.byType(ManageUsersPage), findsOneWidget);

    // Tap on the "Team Activity" tab in the drawer
    await tester.tap(find.text('Team Activity'));
    await tester.pumpAndSettle();

    // Verify that "Team Activity" page is displayed
    expect(find.byType(TeamActivityPage), findsOneWidget);
  });

  testWidgets('Logout button works correctly', (WidgetTester tester) async {
    // Build the widget tree with the mocks
    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboard(),
      ),
    );

    // Wait for Firebase data to be fetched
    await tester.pumpAndSettle();

    // Tap on the logout icon
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Verify if FirebaseAuth sign out was called
    verify(() => mockFirebaseAuth.signOut()).called(1);
  });
}
