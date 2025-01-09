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

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Handle the selected date (e.g., format and display it)
      print(
          "Selected date: ${selectedDate.toLocal()}"); // Replace with your logic
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ganti gambar latar belakang berdasarkan templateIndex
    String backgroundImage =
        'assets/input1.png${widget.templateIndex + 1}.png'; // Ganti dengan nama file gambar latar belakang yang sesuai

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
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Add Date'),
                ),
                const SizedBox(
                    width: 10), // Space between button and text field
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Scrapbook',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    maxLength: 23, // Set max length for title
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Use space evenly to distribute space
                children: [
                  // First Row: Image on the left, Text on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:
                            2, // Adjusted flex to give more space to the image
                        child: Container(
                          height: 120, // Increased height for the image input
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () async {
                              // TODO: Logic untuk menambahkan foto
                              // Simpan path gambar ke _imagePaths[0]
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3, // Adjusted flex for the text field
                        child: Container(
                          height:
                              120, // Increased height to match the image input
                          child: TextField(
                            controller: _textControllers[0],
                            maxLines: 5, // Set to show multiple lines
                            maxLength: 60, // Set max length for text field
                            decoration: InputDecoration(
                              labelText: 'Teks 1',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Second Row: Text on the left, Image on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3, // Adjusted flex for the text field
                        child: Container(
                          height:
                              120, // Increased height to match the image input
                          child: TextField(
                            controller: _textControllers[1],
                            maxLines: 5, // Set to show multiple lines
                            maxLength: 60, // Set max length for text field
                            decoration: InputDecoration(
                              labelText: 'Teks 2',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex:
                            2, // Adjusted flex to give more space to the image
                        child: Container(
                          height: 120, // Increased height for the image input
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () async {
                              // TODO: Logic untuk menambahkan foto
                              // Simpan path gambar ke _imagePaths[1]
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Third Row: Image on the right, Text on the left
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex:
                            2, // Adjusted flex to give more space to the image
                        child: Container(
                          height: 120, // Increased height for the image input
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () async {
                              // TODO: Logic untuk menambahkan foto
                              // Simpan path gambar ke _imagePaths[2]
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3, // Adjusted flex for the text field
                        child: Container(
                          height:
                              120, // Increased height to match the image input
                          child: TextField(
                            controller: _textControllers[2],
                            maxLines: 5, // Set to show multiple lines
                            maxLength: 60, // Set max length for text field
                            decoration: InputDecoration(
                              labelText: 'Teks 3',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Logic untuk menyimpan scrapbook
                // Ambil data dari _titleController, _textControllers, dan _imagePaths
              },
              child: const Text('Simpan Scrapbook'),
            ),
            const SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
