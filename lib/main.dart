import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_flutter/provider/AuthProvider.dart';
import 'package:firebase_flutter/auth/login_screen.dart';
import 'package:firebase_flutter/auth/signup_screen.dart';
import 'package:firebase_flutter/home/home.dart';
import 'package:firebase_flutter/dashboard/admin_dashboard.dart';
import 'package:firebase_flutter/dashboard/team_member_dashboard.dart';
import 'package:firebase_flutter/tasks/add_task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
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
              Provider.of<AuthProvider>(context, listen: false)
                  .register(email: email, password: password, role: role);
              Navigator.pushReplacementNamed(context, '/');
            },
            login: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          '/addTask': (context) => AddTaskPage(),
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String screenState;

  @override
  void initState() {
    super.initState();
    screenState = "Login";
  }

  void login(String email, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? response = await authProvider.login(email: email, password: password);

    if (response != null && response == "Success") {
      changeScreen("Home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response ?? 'Error during login')),
      );
    }
  }

  void signup(String email, String password, String role) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? response = await authProvider.register(
      email: email,
      password: password,
      role: role,
    );

    if (response != null && response == "Success") {
      changeScreen("Login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response ?? 'Error during signup')),
      );
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
          signup: (String email, String password, String role) =>
              signup(email, password, role),
          login: () => changeScreen("Login"),
        );
    }
    return LoginScreen(
      login: (String email, String password) => login(email, password),
      signup: () => changeScreen("Signup"),
    );
  }
}
