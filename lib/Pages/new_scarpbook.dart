import 'package:flutter/material.dart';

class NewScrapbookPage extends StatelessWidget {
  const NewScrapbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Template'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // TODO: Logic to select template and navigate to scrapbook editor
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
    );
  }
}
