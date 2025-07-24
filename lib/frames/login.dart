import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  Color fg = const Color(0xFFF5F5DC);
  Color bg = Colors.purple;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));
      Navigator.pushNamed(context, '/homepage'); // Navigate to home
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _signup() {
    Navigator.pushNamed(context, '/signup'); // Navigate to signup
  }

  void _getEmail() async {
    String email = _newEmailController.text;
    await _auth.sendPasswordResetEmail(email: email!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password reset email sent")),
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _forgotPass() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text("Reset password"),
        content: Container(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _newEmailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFFF5F5DC)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Color(0xFFF5F5DC)),
                  filled: true,
                  fillColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: _getEmail, child: Text("Get Email")),
          TextButton(onPressed: _dismissDialog, child: Text("Cancel")),
        ],
      ),
    );
  }

  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) {
      return "Please enter email";
    }
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Color(0xFFF5F5DC))),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "BOOK FINDER",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "~Organizing Books for Chaotic Brains~",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Color(0xFFF5F5DC)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Email",
                hintStyle: const TextStyle(color: Color(0xFFF5F5DC)),
                filled: true,
                fillColor: Colors.purple,
              ),
              validator: validateEmail,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwController,
              obscureText: true,
              obscuringCharacter: "#",
              style: const TextStyle(color: Color(0xFFF5F5DC)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Password",
                hintStyle: const TextStyle(color: Color(0xFFF5F5DC)),
                filled: true,
                fillColor: Colors.purple,
              ),
              validator: validatePassword,
            ),
            const SizedBox(height: 15),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Color(0xFFF5F5DC)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(color: Color(0xFFF5F5DC)),
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _forgotPass,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Text(
                "Forgot password",
                style: TextStyle(
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
