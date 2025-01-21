import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _showSnackBar(context, 'Username is required!');
      return;
    }

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar(context, 'Enter a valid email address!');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      _showSnackBar(context, 'Password must be at least 6 characters!');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar(context, 'Passwords do not match!');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      _showSnackBar(context, 'Account created successfully!');
      Navigator.pushReplacementNamed(context, '/login');

      // Bersihkan controller
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(context, e);
    } catch (e) {
      _showSnackBar(context, 'An unexpected error occurred.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleFirebaseAuthException(
      BuildContext context, FirebaseAuthException e) {
    String message = 'Registration failed. Please try again.';
    if (e.code == 'email-already-in-use') {
      message = 'Email is already in use.';
    } else if (e.code == 'weak-password') {
      message = 'The password provided is too weak.';
    }
    _showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.asset(
                    'assets/book_icon.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_usernameController, 'Username'),
                const SizedBox(height: 20),
                _buildTextField(
                    _emailController, 'Email', TextInputType.emailAddress),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, 'Password', TextInputType.visiblePassword, true),
                const SizedBox(height: 20),
                _buildTextField(_confirmPasswordController, 'Confirm Password',
                    TextInputType.visiblePassword, true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Already have an account? LOGIN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text,
      bool obscureText = false]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      obscureText:
          obscureText, // Pastikan 'obscureText' menggunakan huruf besar 'T'
    );
  }
}
