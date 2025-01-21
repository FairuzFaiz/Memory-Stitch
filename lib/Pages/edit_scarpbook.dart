import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:memory_stitch/Model/memory_model.dart';
import 'package:memory_stitch/Pages/home_screen.dart';
import 'package:memory_stitch/config.dart';
import 'package:memory_stitch/restapi.dart';

class EditScrapbookPage extends StatefulWidget {
  final MemoryModel memory;
  final int templateIndex;

  const EditScrapbookPage({
    Key? key,
    required this.memory,
    required this.templateIndex,
  }) : super(key: key);

  @override
  _EditScrapbookPageState createState() => _EditScrapbookPageState();
}

class _EditScrapbookPageState extends State<EditScrapbookPage> {
  final judulController = TextEditingController();
  final desc1Controller = TextEditingController();
  final desc2Controller = TextEditingController();
  final desc3Controller = TextEditingController();
  final tanggalController = TextEditingController();
  late List<String> imagePaths;

  final DataService dataService = DataService();
  final String fileUri = 'https://io.etter.cloud/v4/upload';
  final String token = '67072e7f1be56c51cde09d97';
  final String project = 'memory';

  @override
  void initState() {
    super.initState();

    judulController.text = widget.memory.judul;
    desc1Controller.text = widget.memory.desc1;
    desc2Controller.text = widget.memory.desc2;
    desc3Controller.text = widget.memory.desc3;
    tanggalController.text = widget.memory.tanggal;
    imagePaths = [
      widget.memory.pict1,
      widget.memory.pict2,
      widget.memory.pict3,
    ];
  }

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
            imagePaths[index] = file['file_name']; 
          });
        } else {
          _showSnackBar('Upload failed');
        }
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveData() async {
    try {
      String templateName = 'input${widget.templateIndex + 1}.png';

      String updateValue = [
        judulController.text,
        desc1Controller.text,
        desc2Controller.text,
        desc3Controller.text,
        imagePaths[0],
        imagePaths[1],
        imagePaths[2],
        tanggalController.text,
        templateName,
      ].join('~');

      bool updateStatus = await dataService.updateId(
        'judul~desc1~desc2~desc3~pict1~pict2~pict3~tanggal~template',
        judulController.text +
            '~' +
            desc1Controller.text +
            '~' +
            desc2Controller.text +
            '~' +
            desc3Controller.text +
            '~' +
            imagePaths[0] +
            '~' +
            imagePaths[1] +
            '~' +
            imagePaths[2] +
            '~' +
            tanggalController.text +
            '~' +
            templateName,
        token,
        project,
        'memory',
        appid,
        widget.memory.id,
      );

      if (updateStatus) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showSnackBar('Failed to update data');
      }
    } catch (e) {
      _showSnackBar('Error saving data: $e');
    }
  }

  Future<bool> updateId(String update_field, String update_value, String token,
      String project, String collection, String appid, String id) async {
    String uri = 'https://io.etter.cloud/v4/update_id';

    try {
      final response = await http.put(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'update_field': update_field,
          'update_value': update_value,
          'token': token,
          'project': project,
          'collection': collection,
          'appid': appid,
          'id': id,
        },
      );

      if (kDebugMode) {
        print('API Status Code: ${response.statusCode}');
        print('API Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateId: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = 'assets/input${widget.templateIndex + 1}.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scrapbook'),
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
              children: [
                Expanded(
                  child: TextField(
                    controller: judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Scrapbook',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Edit Date'),
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
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAndTextField(
    TextEditingController textController,
    int index, {
    bool isImageLeft = true,
  }) {
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
      child: GestureDetector(
        onTap: () => _pickImage(index),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imagePaths[index].isNotEmpty
              ? Image.network(
                  fileUri + imagePaths[index],
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.add_a_photo, size: 50),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController) {
    return Expanded(
      flex: 3,
      child: TextField(
        controller: textController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
          fillColor: Colors.white70,
        filled: true,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        tanggalController.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
      });
    }
  }
}
