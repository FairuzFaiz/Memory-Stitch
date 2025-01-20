import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:memory_stitch/Pages/home_screen.dart';
import 'package:memory_stitch/config.dart';
import 'package:memory_stitch/restapi.dart';

class NewInputScrapbookPage extends StatefulWidget {
  final int templateIndex;

  const NewInputScrapbookPage({super.key, required this.templateIndex});

  @override
  _NewInputScrapbookPageState createState() => _NewInputScrapbookPageState();
}

class _NewInputScrapbookPageState extends State<NewInputScrapbookPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController desc1Controller = TextEditingController();
  final TextEditingController desc2Controller = TextEditingController();
  final TextEditingController desc3Controller = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  DataService dataService = DataService();

  // Simpan path gambar untuk 3 foto
  List<String> _imagePaths = ["-", "-", "-"];

  // URL dasar untuk gambar (contoh: server API atau folder lokal)
  final String fileUri = 'https://io.etter.cloud/v4/upload';

  // Token dan project untuk upload
  final String token = '67072e7f1be56c51cde09d97';
  final String project = 'memory';

  // Function to pick and upload an image
  Future<void> _pickImage(int index) async {
    try {
      var picked = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (picked != null) {
        var imageBytes = picked.files.first.bytes!;
        String ext = picked.files.first.extension ?? 'jpg';

        // Panggil fungsi upload
        String? response = await dataService.upload(
          token,
          project,
          imageBytes,
          ext,
        );

        if (response != null) {
          var file = jsonDecode(response);
          setState(() {
            _imagePaths[index] = file['file_name']; // Simpan nama file
          });
        } else {
          _showSnackBar('Upload failed');
        }
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  // Function to show snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Function to save data
  Future<void> _saveData() async {
    try {
      String templateName = 'input${widget.templateIndex + 1}.png';

      final String response = await dataService.insertMemory(
        appid,
        judulController.text,
        desc1Controller.text,
        desc2Controller.text,
        desc3Controller.text,
        _imagePaths[0], // pict1
        _imagePaths[1], // pict2
        _imagePaths[2], // pict3
        tanggalController.text,
        templateName,
      );

      if (response != '[]') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } else {
        if (kDebugMode) {
          print("Error response: $response");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = 'assets/input${widget.templateIndex + 1}.png';

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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Add Date'),
                ),
                const SizedBox(width: 10),
                Text(
                  tanggalController.text.isEmpty
                      ? 'Pilih tanggal'
                      : tanggalController.text,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: judulController,
                    decoration: InputDecoration(
                      labelText: 'Judul Scrapbook',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    maxLength: 23,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageAndTextField(desc1Controller, 0),
                  _buildImageAndTextField(desc2Controller, 1,
                      isImageLeft: false),
                  _buildImageAndTextField(desc3Controller, 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Simpan Scrapbook'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAndTextField(
      TextEditingController textController, int index,
      {bool isImageLeft = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: isImageLeft
          ? [
              _buildImageInput(index),
              const SizedBox(width: 10),
              _buildTextField(textController),
            ]
          : [
              _buildTextField(textController),
              const SizedBox(width: 10),
              _buildImageInput(index),
            ],
    );
  }

  Widget _buildImageInput(int index) {
    return Expanded(
      flex: 2,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            if (_imagePaths[index] != "-")
              Positioned.fill(
                child: Image.network(
                  '$fileUri${_imagePaths[index]}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.broken_image, size: 50));
                  },
                ),
              ),
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: () => _pickImage(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController) {
    return Expanded(
      flex: 3,
      child: Container(
        height: 120,
        child: TextField(
          controller: textController,
          maxLines: 3,
          maxLength: 60,
          decoration: InputDecoration(
            labelText: 'Teks',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final String formattedDate =
          DateFormat('dd-MMM-yyyy').format(selectedDate);
      setState(() {
        tanggalController.text = formattedDate;
      });
    }
  }
}