import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/auth/AuthService.dart';
import 'package:firebase_flutter/auth/login_screen.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';
import 'package:firebase_flutter/home/home.dart'; // Updated to display Firestore data
import 'package:flutter/material.dart';

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
      title: 'Firebase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
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

  void signup(String email, String password) async {
    String? response = await AuthService().registration(email: email, password: password);

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
          login: (String email, String password) => {login(email, password)},
          signup: () => {changeScreen("Signup")},
        );
      case "Home":
        return const HomePage();
      case "Signup":
        return SignupScreen(
          signup: (String email, String password) => {signup(email, password)},
        );
    }
    return LoginScreen(
      login: (String email, String password) => {login(email, password)},
      signup: () => {changeScreen("Signup")},
    );
  }
}

