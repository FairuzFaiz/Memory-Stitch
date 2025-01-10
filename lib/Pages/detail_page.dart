import 'package:flutter/material.dart';
import 'package:memory_stitch/config.dart';

class DetailPage extends StatelessWidget {
  final String title; // Scrapbook title
  final String date; // Date of creation
  final List<String> texts; // List to hold the text fields
  final List<String> imagePaths; // List to hold the image paths
  final String templateName; // Template type for background

  const DetailPage({
    Key? key,
    required this.title,
    required this.date,
    required this.texts,
    required this.imagePaths,
    required this.templateName, // Template parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String backgroundImage = 'assets/$templateName';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Scrapbook'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage), // Background image
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Display Title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.8),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            // Display Date
            Text(
              date,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            // Display Image and Text Sections
            Expanded(
              child: ListView.builder(
                itemCount: texts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        if (index < imagePaths.length)
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                                image: imagePaths[index].isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            fileUri + imagePaths[index]),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: imagePaths[index].isEmpty
                                  ? Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50),
                                    )
                                  : null,
                            ),
                          ),
                        if (index < imagePaths.length)
                          const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 120,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              texts[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
