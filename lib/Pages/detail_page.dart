import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title; // Scrapbook title
  final String date; // Date of creation
  final List<String> texts; // List to hold the text fields
  final List<String> imagePaths; // List to hold the image paths
  final String template; // Template type for background

  const DetailPage({
    Key? key,
    required this.title,
    required this.date,
    required this.texts,
    required this.imagePaths,
    required this.template, // New parameter for template
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Static background image based on the template
    String backgroundImage;
    switch (template) {
      case 'Template 1':
        backgroundImage = 'assets/template1_bg.jpg'; // Replace with actual path
        break;
      case 'Template 2':
        backgroundImage = 'assets/template2_bg.jpg'; // Replace with actual path
        break;
      default:
        backgroundImage = 'assets/default_bg.jpg'; // Fallback background
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Scrapbook'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Logic to handle edit action
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                backgroundImage), // Background image based on template
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Row for Title and Date
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Date
            Text(
              date,
              style: TextStyle(fontSize: 16, color: Colors.grey[300]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First Row: Image on the left, Text on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(imagePaths[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
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
                            texts[0],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Second Row: Text on the left, Image on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            texts[1],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(imagePaths[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Third Row: Image on the left, Text on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(imagePaths[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
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
                            texts[2],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
