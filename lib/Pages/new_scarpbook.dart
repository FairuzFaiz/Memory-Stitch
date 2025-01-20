import 'package:flutter/material.dart';
import 'new_input_scarpbook.dart'; // Import halaman input scrapbook

class NewScrapbookPage extends StatelessWidget {
  const NewScrapbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Template'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/scrapbook_bg.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(4, (index) {
              return Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // Tampilkan dialog konfirmasi
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text(
                              'Apakah Anda yakin ingin memilih template ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigasi ke new_input_scarpbook.dart dengan template yang dipilih
                                Navigator.of(context).pop(); // Tutup dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewInputScrapbookPage(
                                        templateIndex: index),
                                  ),
                                );
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/template${index + 1}.png', // Ganti dengan nama file template yang sesuai
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Template ${index + 1}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
