import 'package:flutter/material.dart';

class NewInputScrapbookPage extends StatefulWidget {
  final int templateIndex;

  const NewInputScrapbookPage({super.key, required this.templateIndex});

  @override
  _NewInputScrapbookPageState createState() => _NewInputScrapbookPageState();
}

class _NewInputScrapbookPageState extends State<NewInputScrapbookPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _textControllers =
      List.generate(3, (_) => TextEditingController());
  final List<String> _imagePaths = List.filled(3, '');

  @override
  Widget build(BuildContext context) {
    // Ganti gambar latar belakang berdasarkan templateIndex
    String backgroundImage =
        'assets/template_background${widget.templateIndex + 1}.jpg'; // Ganti dengan nama file gambar latar belakang yang sesuai

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Scrapbook'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Scrapbook',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < 3; i++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Teks ${i + 1}',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () async {
                        // TODO: Logic untuk menambahkan foto
                        // Misalnya, menggunakan image picker untuk memilih gambar
                        // Simpan path gambar ke _imagePaths[i]
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_imagePaths[i].isNotEmpty)
                  Image.asset(
                    _imagePaths[i], // Ganti dengan path gambar yang dipilih
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  // TODO: Logic untuk menyimpan scrapbook
                  // Ambil data dari _titleController, _textControllers, dan _imagePaths
                },
                child: const Text('Simpan Scrapbook'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
