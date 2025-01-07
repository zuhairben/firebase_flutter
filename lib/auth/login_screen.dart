import 'package:flutter/material.dart';
import 'package:firebase_flutter/auth/AuthService.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password) login;
  final void Function() signup;

  const LoginScreen({super.key, required this.login, required this.signup});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F1),
      appBar: AppBar(
        title: Text(
          "Team Sync",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A69BD),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF323130),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Login to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF605E5C),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF4A69BD)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0xFF4A69BD)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: !isPasswordVisible,
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A69BD)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF4A69BD),
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFF4A69BD)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  backgroundColor: const Color(0xFF4A69BD),
                ),
                onPressed: () {
                  widget.login(
                    usernameController.text,
                    passwordController.text,
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: widget.signup,
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: const Color(0xFF4A69BD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A69BD),
                  side: const BorderSide(color: Color(0xFF4A69BD)),
                ),
                onPressed: () async {
                  try {
                    final userCredential =
                    await AuthService().signInWithGoogle();
                    if (userCredential.user != null) {
                      final role = await AuthService().getUserRole();
                      if (role == 'Admin') {
                        Navigator.pushReplacementNamed(
                            context, '/adminDashboard');
                      } else {
                        Navigator.pushReplacementNamed(
                            context, '/teamMemberDashboard');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User information is missing!"),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Google Sign-In Failed: $e"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
