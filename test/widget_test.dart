import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_flutter/auth/login_screen.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';
import 'package:firebase_flutter/auth/AuthService.dart';
import 'package:firebase_flutter/tasks/add_task_page.dart';
import 'package:firebase_flutter/models/task_model.dart';
import 'package:firebase_flutter/tasks/task_service.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthService {}

class MockTaskService extends Mock implements TaskService {}

void main() {
  group('Widget Tests - LoginScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('Renders LoginScreen widgets correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {},
            signup: () {},
          ),
        ),
      );

      expect(find.text("Welcome Back!"), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text("Login"), findsOneWidget);
    });

    testWidgets('Login button triggers login callback', (WidgetTester tester) async {
      String? capturedEmail;
      String? capturedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            login: (email, password) {
              capturedEmail = email;
              capturedPassword = password;
            },
            signup: () {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text("Login"));

      expect(capturedEmail, 'test@example.com');
      expect(capturedPassword, 'password123');
    });
  });

  group('Widget Tests - SignupScreen', () {
    testWidgets('Renders SignupScreen correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(
            signup: (email, password, role) {},
            login: () {},
          ),
        ),
      );

      expect(find.text("Create an Account"), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(DropdownButtonFormField), findsOneWidget);
    });
  });

  group('Widget Tests - AddTaskPage', () {
    testWidgets('Renders AddTaskPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AddTaskPage(),
        ),
      );

      expect(find.text('Add Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('Validates form inputs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AddTaskPage(),
        ),
      );

      await tester.tap(find.text('Add Task'));
      await tester.pump();

      expect(find.text('Enter a title'), findsOneWidget);
      expect(find.text('Enter a description'), findsOneWidget);
    });
  });

  group('Unit Tests - AuthService', () {
    test('Registration returns success', () async {
      final authService = MockAuthService();

      when(authService.registration(
        email: 'test@example.com',
        password: 'password123',
        role: 'Team Member',
      )).thenAnswer((_) async => 'Success');

      final result = await authService.registration(
        email: 'test@example.com',
        password: 'password123',
        role: 'Team Member',
      );

      expect(result, 'Success');
    });

    test('Login fails with wrong password', () async {
      final authService = MockAuthService();

      when(authService.login(email: 'test@example.com', password: 'wrongpassword'))
          .thenAnswer((_) async => 'Wrong password provided for that user.');

      final result = await authService.login(
        email: 'test@example.com',
        password: 'wrongpassword',
      );

      expect(result, 'Wrong password provided for that user.');
    });
  });

  group('Unit Tests - TaskService', () {
    late MockTaskService mockTaskService;

    setUp(() {
      mockTaskService = MockTaskService();
    });

    test('Add task successfully', () async {
      final task = Task(
        id: '123',
        title: 'Test Task',
        description: 'A task for testing',
        assignedTo: 'test@example.com',
        status: 'To Do',
        dueDate: DateTime.now(),
        createdBy: 'admin@example.com',
      );

      when(mockTaskService.addTask(task)).thenAnswer((_) async => {});

      await mockTaskService.addTask(task);

      verify(mockTaskService.addTask(task)).called(1);
    });

    test('Update task status successfully', () async {
      const taskId = '123';
      const newStatus = 'Complete';

      when(mockTaskService.updateTaskStatus(taskId, newStatus))
          .thenAnswer((_) async => {});

      await mockTaskService.updateTaskStatus(taskId, newStatus);

      verify(mockTaskService.updateTaskStatus(taskId, newStatus)).called(1);
    });
  });
}
