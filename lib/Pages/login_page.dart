import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(), // Kosongkan title karena kita akan menambahkannya di body
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Menambahkan bagian logo di atas
              Padding(
                padding: const EdgeInsets.symmetric(), // Jarak dari atas
                child: Image.asset(
                  'assets/book_icon.png', // Pastikan Anda menambahkan ikon buku di folder assets
                  height: 100,
                ),
              ),
              const SizedBox(height: 10), // Memberi jarak antara logo dan teks
              // Teks "Welcome To MemoryStitch"
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Menyusun teks di tengah
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0), // Jarak kanan
                        child: Text(
                          'Welcome To',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0), // Jarak kiri
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
              ElevatedButton.icon(
                onPressed: () {
                  // Logic untuk login dengan Facebook
                },
                icon: const Icon(
                  Icons.facebook,
                  color: Colors.white,
                ),
                label: const Text(
                  'Continue with Facebook',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3b5998),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Logic untuk login dengan Google
                },
                icon: const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFdb4437),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Logic untuk menggunakan email
                },
                child: const Text(
                  'Or Use Email',
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
    );
  }
}
