import 'package:flutter/material.dart';
import 'package:memory_stitch/Pages/login_page.dart';
import 'package:memory_stitch/Pages/login_email_page.dart';

void main() {
  runApp(const MemoryStitchApp());
}

class MemoryStitchApp extends StatelessWidget {
  const MemoryStitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Stitch',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login_email': (context) => const LoginPageEmail(),
      },
    );
  }
}
