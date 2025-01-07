import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final void Function(String email, String password, String role) signup;
  final void Function() login; // Added login callback for navigation

  const SignupScreen({super.key, required this.signup, required this.login});

  @override
  State<StatefulWidget> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Team Member'; // Default role
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
                "Create an Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF323130),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign up to get started",
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                items: ['Admin', 'Team Member']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF4A69BD)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Role',
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
                  widget.signup(
                    usernameController.text,
                    passwordController.text,
                    selectedRole,
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already signed up?",
                    style: TextStyle(
                      color: const Color(0xFF605E5C),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.login,
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: const Color(0xFF4A69BD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
