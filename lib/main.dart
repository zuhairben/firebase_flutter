import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/auth/AuthService.dart';
import 'package:firebase_flutter/auth/login_screen.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';
import 'package:firebase_flutter/home/home.dart';
import 'package:firebase_flutter/tasks/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_flutter/dashboard/admin_dashboard.dart';
import 'package:firebase_flutter/dashboard/team_member_dashboard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase initializes before running
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomePage(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/teamMemberDashboard': (context) => TeamMemberDashboard(),
        '/signup': (context) => SignupScreen(
          signup: (email, password, role) {
            Navigator.pushReplacementNamed(context, '/');
          },
          login: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        '/addTask': (context) => AddTaskPage(),
      },

    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String screenState;

  @override
  void initState() {
    super.initState();
    screenState = "Login";
  }

  void login(String email, String password) async {
    String? response = await AuthService().login(email: email, password: password);

    if (response != null) {
      if (response == "Success") {
        changeScreen("Home");
      }
    }
  }

  void signup(String email, String password, String role) async {
    String? response = await AuthService().registration(email: email, password: password, role: role);

    if (response != null) {
      if (response == "Success") {
        changeScreen("Login");
      }
    }
  }


  void changeScreen(String screen) {
    setState(() {
      screenState = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (screenState) {
      case "Login":
        return LoginScreen(
          login: (String email, String password) => login(email, password),
          signup: () => changeScreen("Signup"),
        );
      case "Home":
        return const HomePage();
      case "Signup":
        return SignupScreen(
          signup: (String email, String password, String role) => signup(email, password, role),
          login: () => changeScreen("Login"),
        );
    }
    return LoginScreen(
      login: (String email, String password) => login(email, password),
      signup: () => changeScreen("Signup"),
    );
  }
}

