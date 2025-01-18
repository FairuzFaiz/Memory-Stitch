import 'package:flutter/material.dart';  
import 'package:firebase_auth/firebase_auth.dart';  
  
class LoginPageEmail extends StatelessWidget {  
  LoginPageEmail({super.key});  
  
  final TextEditingController _emailController = TextEditingController();  
  final TextEditingController _passwordController = TextEditingController();  
  
  Future<void> _loginWithEmailPassword(BuildContext context) async {  
    final String email = _emailController.text.trim();  
    final String password = _passwordController.text.trim();  
    if (email.isEmpty || password.isEmpty) {  
      ScaffoldMessenger.of(context).showSnackBar(  
        const SnackBar(content: Text('Email and password must not be empty.')),  
      );  
      return;  
    }  
    try {  
      await FirebaseAuth.instance.signInWithEmailAndPassword(  
        email: email,  
        password: password,  
      );  
  
      ScaffoldMessenger.of(context).showSnackBar(  
        const SnackBar(content: Text('Login successful!')),  
      );  
      Navigator.pushReplacementNamed(context, '/home');  
    } on FirebaseAuthException catch (e) {  
      String message;  
      if (e.code == 'user-not-found') {  
        message = 'User not found.';  
      } else if (e.code == 'wrong-password') {  
        message = 'Wrong password.';  
      } else {  
        message = 'Login failed. Please try again.';  
      }  
      ScaffoldMessenger.of(context)  
          .showSnackBar(SnackBar(content: Text(message)));  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        backgroundColor: Colors.transparent,  
        elevation: 0,  
        title: Container(),  
      ),  
      body: Center(  
        child: Padding(  
          padding: const EdgeInsets.all(16.0),  
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.center,  
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [  
              Padding(  
                padding: const EdgeInsets.symmetric(),  
                child: Image.asset(  
                  'assets/book_icon.png',  
                  height: 100,  
                ),  
              ),  
              const SizedBox(height: 10),  
              Column(  
                children: [  
                  Padding(  
                    padding: const EdgeInsets.only(left: 0.0),  
                    child: Text(  
                      'MemoryStitch',  
                      style: TextStyle(  
                        fontSize: 34,  
                        fontWeight: FontWeight.bold,  
                        color: Colors.brown,  
                      ),  
                    ),  
                  ),  
                ],  
              ),  
              const SizedBox(height: 30),  
              const Text(  
                "Let's get started!",  
                style: TextStyle(  
                  fontSize: 24,  
                  fontWeight: FontWeight.w600,  
                  color: Colors.black,  
                ),  
              ),  
              const SizedBox(height: 30),  
              TextField(  
                controller: _emailController,  
                decoration: InputDecoration(  
                  labelText: 'Email',  
                  border: OutlineInputBorder(  
                    borderRadius: BorderRadius.circular(8.0),  
                  ),  
                  prefixIcon: const Icon(Icons.email),  
                ),  
                keyboardType: TextInputType.emailAddress,  
              ),  
              const SizedBox(height: 20),  
              TextField(  
                controller: _passwordController,  
                decoration: InputDecoration(  
                  labelText: 'Password',  
                  border: OutlineInputBorder(  
                    borderRadius: BorderRadius.circular(8.0),  
                  ),  
                  prefixIcon: const Icon(Icons.lock),  
                ),  
                obscureText: true,  
              ),  
              const SizedBox(height: 30),  
              ElevatedButton(  
                onPressed: () => _loginWithEmailPassword(context),  
                style: ElevatedButton.styleFrom(  
                  backgroundColor: Colors.brown,  
                  minimumSize: const Size(double.infinity, 50),  
                  shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(8.0),  
                  ),  
                ),  
                child: const Text(  
                  'Login',  
                  style: TextStyle(color: Colors.white, fontSize: 16),  
                ),  
              ),  
              const SizedBox(height: 20),  
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [  
                  const Text(  
                    "Don't have an account yet?",  
                    style: TextStyle(color: Colors.black),  
                  ),  
                  TextButton(  
                    onPressed: () {  
                      Navigator.pushNamed(context, '/register');  
                    },  
                    child: const Text(  
                      'Create an Account',  
                      style: TextStyle(  
                        color: Colors.blue,  
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
