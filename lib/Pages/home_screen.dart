import 'package:flutter/material.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Memory> _memories = [
    Memory(
      id: '1',
      title: 'Kenangan 1',
      description: 'Ini adalah deskripsi singkat kenangan 1.',
      location: 'Jakarta',
      date: DateTime(2025, 1, 1),
      mood: 'Bahagia',
      images: ['assets/images/photo1.jpg'],
      template: 'Template 1',
    ),
    Memory(
      id: '2',
      title: 'Kenangan 2',
      description: 'Ini adalah deskripsi singkat kenangan 2.',
      location: 'Bandung',
      date: DateTime(2025, 1, 2),
      mood: 'Sedih',
      images: ['assets/images/photo2.jpg'],
      template: 'Template 2',
    ),
    // Tambahkan lebih banyak data jika diperlukan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // TODO: LOGIC BACKEND UNTUK NAVIGASI KE HALAMAN TAMBAH SCRAPBOOK
      Navigator.pushNamed(context, '/add-memory');
    } else if (index == 2) {
      // TODO: LOGIC BACKEND UNTUK NAVIGASI KE HALAMAN PROFILE
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MemoryStitch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: LOGIC BACKEND UNTUK FITUR PENCARIAN
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // TODO: LOGIC BACKEND UNTUK FITUR PENGURUTAN
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/scrapbook_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Daftar Scrapbook Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _memories.length,
                  itemBuilder: (context, index) {
                    return MemoryCard(
                      memory: _memories[index],
                      onEdit: () {
                        // TODO: LOGIC BACKEND UNTUK EDIT SCRAPBOOK
                      },
                      onDelete: () {
                        // TODO: LOGIC BACKEND UNTUK HAPUS SCRAPBOOK
                      },
                      onDownload: () {
                        // TODO: LOGIC BACKEND UNTUK UNDUH SCRAPBOOK
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  MemoryCard({
    required this.memory,
    required this.onEdit,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  memory.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Edit') {
                      onEdit();
                    } else if (value == 'Hapus') {
                      onDelete();
                    } else if (value == 'Unduh') {
                      onDownload();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Hapus',
                      child: Text('Hapus'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Unduh',
                      child: Text('Unduh'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              memory.date.toLocal().toString().split(' ')[0],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              memory.description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
