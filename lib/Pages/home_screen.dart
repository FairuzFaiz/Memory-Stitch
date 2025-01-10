import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memory_stitch/Model/memory_model.dart';
import 'package:memory_stitch/restapi.dart';
import 'new_scarpbook.dart';
import 'detail_page.dart';
import 'package:memory_stitch/config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchKeyword = TextEditingController();
  bool isSearching = false;
  bool isLoading = true;

  int _selectedIndex = 0;
  List<MemoryModel> memoriesList = [];
  final DataService ds = DataService();
  List<MemoryModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchAllActivities();
    searchKeyword.clear(); // Pastikan kosong saat halaman dimuat
    filterActivities('');
  }

  Future<void> fetchAllActivities() async {
    try {
      final response = await ds.selectAll(token, project, 'memory', appid);
      print('Response JSON: $response'); // Debugging response
      final List data = jsonDecode(response);
      memoriesList = data.map((e) => MemoryModel.fromJson(e)).toList();
      filteredList = data.map((e) => MemoryModel.fromJson(e)).toList();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterActivities(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredList = List.from(memoriesList);
      } else {
        filteredList = memoriesList
            .where((item) =>
                item.judul.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewScrapbookPage()),
      );
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile_page');
    }
  }

  void _navigateToDetailPage(MemoryModel memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          title: memory.judul,
          date: memory.tanggal,
          texts: [memory.desc1, memory.desc2, memory.desc3],
          imagePaths: [memory.pict1, memory.pict2, memory.pict3],
          templateName: memory.template,
        ),
      ),
    );
  }

  Future<void> reloadData(dynamic value) async {
    await fetchAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text(
                'MemoryStitch',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : TextField(
                controller: searchKeyword,
                autofocus: true,
                onChanged: filterActivities, // Panggil fungsi filter
                decoration: const InputDecoration(
                  hintText: 'Cari berdasarkan judul...',
                  border: InputBorder.none,
                ),
              ),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchKeyword.clear(); // Hapus teks pencarian
                  filterActivities(''); // Reset hasil pencarian
                }
                isSearching = !isSearching; // Toggle mode pencarian
              });
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
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateToDetailPage(filteredList[index]),
                      child: MemoryCard(
                        memory: filteredList[index],
                        onEdit: () {
                          // Tambahkan logika edit
                        },
                        onDelete: () async {
                          try {
                            setState(() {
                              isLoading = true; // Tampilkan loading indicator
                            });

                            bool success = await ds.removeId(
                              token,
                              project,
                              'memory', // Nama koleksi
                              appid,
                              filteredList[index]
                                  .id, // ID item yang ingin dihapus
                            );

                            if (success) {
                              setState(() {
                                memoriesList
                                    .removeAt(index); // Hapus dari daftar utama
                                filteredList.removeAt(
                                    index); // Hapus dari daftar yang difilter
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Berhasil menghapus memory')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Gagal menghapus memory')),
                              );
                            }
                          } catch (e) {
                            print('Error deleting memory: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Terjadi kesalahan saat menghapus memory')),
                            );
                          } finally {
                            setState(() {
                              isLoading =
                                  false; // Sembunyikan loading indicator
                            });
                          }
                        },
                        onDownload: () {
                          // Tambahkan logika unduh
                        },
                      ),
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
                color: Colors.brown,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.4),
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
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final MemoryModel memory;
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
                  memory.judul,
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
              memory.tanggal,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${memory.desc1}',
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
