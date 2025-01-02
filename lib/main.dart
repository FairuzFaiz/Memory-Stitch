import 'package:flutter/material.dart';
import 'package:memory_stitch/Pages/login_page.dart';

void main() {
  runApp(const MemoryStitchApp());
}

class MemoryStitchApp extends StatelessWidget {
  const MemoryStitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
