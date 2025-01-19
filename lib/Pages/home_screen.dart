import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memory_stitch/Model/memory_model.dart';
import 'package:memory_stitch/restapi.dart';
import 'new_scarpbook.dart';
import 'detail_page.dart';
import 'package:memory_stitch/config.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'edit_scarpbook.dart';

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

  String _searchQuery = '';
  String _selectedCategory = 'All';

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
      filteredList = memoriesList; // Initialize filteredList
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          child: AppBar(
            backgroundColor: Colors.brown,
            title: Text(
              'MemoryStitch',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false, // Remove back button
          ),
        ),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.5), // Adjusted opacity
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Daftar Scrapbook Anda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Search and Category Filter
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: searchKeyword,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            filterActivities(_searchQuery);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by title',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.brown),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort, color: Colors.brown),
                    onSelected: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return <String>['All', 'Category1', 'Category2']
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScrapbookPage(
                            key: key,
                            templateIndex: int.parse(memory.template),
                            initialTitle: memory.judul,
                            initialDesc1: memory.desc1,
                            initialDesc2: memory.desc2,
                            initialDesc3: memory.desc3,
                            initialDate: memory.tanggal,
                            initialImagePaths: [
                              memory.pict1,
                              memory.pict2,
                              memory.pict3
                            ],
                          ),
                        ),
                      );
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
