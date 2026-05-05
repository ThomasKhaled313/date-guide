import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: InputDecoration(labelText: "Password"), obscureText: true,),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => auth.login(email.text, password.text),
              child: Text("Login"),
            ),

            ElevatedButton(
              onPressed: () => auth.signUp(email.text, password.text),
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}