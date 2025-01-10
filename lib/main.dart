// import 'package:flutter/material.dart';
// import 'package:memory_stitch/pages/profile_page.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter/foundation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Enabled only in debug mode
//       builder: (context) => const MemoryStitchApp(),
//     ),
//   );
// }

// class MemoryStitchApp extends StatelessWidget {
//   const MemoryStitchApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       useInheritedMediaQuery: true,
//       locale:
//           DevicePreview.locale(context), // Retrieve settings from DevicePreview
//       builder: DevicePreview.appBuilder, // Use builder from DevicePreview
//       title: 'Memory Stitch',
//       theme: ThemeData(
//         primarySwatch: Colors.brown,
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/profile_page': (context) => ProfilePage(),
//       },
//     );
//   }
// }



//ini void main yang bisa dipake
import 'package:flutter/material.dart';
import 'package:memory_stitch/Pages/home_screen.dart';
import 'package:memory_stitch/Pages/login_page.dart';
import 'package:memory_stitch/Pages/login_email_page.dart';
import 'package:memory_stitch/Pages/register_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
//import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Aktifkan hanya di mode debug
      builder: (context) => const MemoryStitchApp(),
    ),
  );
}

class MemoryStitchApp extends StatelessWidget {
  const MemoryStitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale:
          DevicePreview.locale(context), // Ambil pengaturan dari DevicePreview
      builder: DevicePreview.appBuilder, // Gunakan builder dari DevicePreview
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
        '/login_email': (context) => LoginPageEmail(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
