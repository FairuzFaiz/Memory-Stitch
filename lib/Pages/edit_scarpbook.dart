// filepath: /D:/smt5-ITENAS/ISB-311 Sistemmasi Selular 04-102/Projects/tugas_akhir_praktikum/Memory-Stitch/lib/Pages/edit_memory_page.dart
import 'package:flutter/material.dart';
import 'package:memory_stitch/Model/memory_model.dart';

class EditMemoryPage extends StatefulWidget {
  final MemoryModel memory;

  EditMemoryPage({required this.memory});

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memory.judul);
    _descriptionController = TextEditingController(text: widget.memory.desc1);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Memory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the edited memory
                    setState(() {
                      widget.memory.judul = _titleController.text;
                      widget.memory.desc1 = _descriptionController.text;
                    });
                    Navigator.pop(context, widget.memory);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
