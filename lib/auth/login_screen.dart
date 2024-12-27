import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_flutter/auth/AuthService.dart'; // Import your AuthService

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase App")),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  widget.login(
                    usernameController.text,
                    passwordController.text,
                  );
                },
                child: const Text("Login"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: widget.signup,
                child: const Text("Signup"),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Center(child: Text("OR", style: TextStyle(fontSize: 16))),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue),
                  foregroundColor: Colors.blue,
                  elevation: 4,
                ),
                onPressed: () async {
                  try {
                    final userCredential =
                    await AuthService().signInWithGoogle();
                    if (userCredential.user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Welcome, ${userCredential.user!.displayName}!",
                          ),
                        ),
                      );
                      // Navigate to home screen or perform any action
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
            ),
          ],
        ),
      ),
    );
  }
}
