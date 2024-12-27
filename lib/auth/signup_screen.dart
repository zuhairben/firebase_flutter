import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final Set<void> Function(String email,String password) signup;

  const SignupScreen({super.key, required this.signup});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Firebase app")),
        body: Center(
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(8),
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
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),
                    onPressed: (){
                      widget.signup(usernameController.text,passwordController.text);
                    }, child: const Text("Signup")),
              )
            ],
          ),
        ));
  }
}