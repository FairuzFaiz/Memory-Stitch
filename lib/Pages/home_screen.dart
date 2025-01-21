// import 'dart:convert';
// import 'package:memory_stitch/Pages/edit_scarpbook.dart';
// import 'package:memory_stitch/restapi.dart';
// import 'new_scarpbook.dart';
// import 'detail_page.dart';
// import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
// import 'package:memory_stitch/config.dart';
// import 'package:flutter/material.dart';
// import 'package:memory_stitch/Model/memory_model.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final searchKeyword = TextEditingController();
//   bool isSearching = false;
//   bool isLoading = true;

//   int _selectedIndex = 0;
//   List<MemoryModel> memoriesList = [];
//   final DataService ds = DataService();
//   List<MemoryModel> filteredList = [];

//   String _searchQuery = '';
//   String _selectedCategory = 'All';

//   @override
//   void initState() {
//     super.initState();
//     fetchAllActivities();
//     searchKeyword.clear(); // Pastikan kosong saat halaman dimuat
//     filterActivities('');
//   }

//   Future<void> fetchAllActivities() async {
//     try {
//       final response = await ds.selectAll(token, project, 'memory', appid);
//       print('Response JSON: $response'); // Debugging response
//       final List data = jsonDecode(response);
//       memoriesList = data.map((e) => MemoryModel.fromJson(e)).toList();
//       filteredList = memoriesList; // Initialize filteredList
//       setState(() {
//         isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterActivities(String keyword) {
//     setState(() {
//       if (keyword.isEmpty) {
//         filteredList = List.from(memoriesList);
//       } else {
//         filteredList = memoriesList
//             .where((item) =>
//                 item.judul.toLowerCase().contains(keyword.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const NewScrapbookPage()),
//       );
//     } else if (index == 2) {
//       Navigator.pushNamed(context, '/profile_page');
//     }
//   }

//   void _navigateToDetailPage(MemoryModel memory) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailPage(
//           title: memory.judul,
//           date: memory.tanggal,
//           texts: [memory.desc1, memory.desc2, memory.desc3],
//           imagePaths: [memory.pict1, memory.pict2, memory.pict3],
//           templateName: memory.template,
//         ),
//       ),
//     );
//   }

//   Future<void> reloadData(dynamic value) async {
//     await fetchAllActivities();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.vertical(),
//           child: AppBar(
//             backgroundColor: Colors.brown,
//             title: Text(
//               'MemoryStitch',
//               style: GoogleFonts.poppins(color: Colors.white),
//             ),
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/scrapbook_bg.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 5),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.brown.withOpacity(0.5), // Adjusted opacity
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   'Daftar Scrapbook Anda',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Search and Category Filter
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey[200],
//                       ),
//                       child: TextField(
//                         controller: searchKeyword,
//                         onChanged: (value) {
//                           setState(() {
//                             _searchQuery = value;
//                             filterActivities(_searchQuery);
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Search by title',
//                           border: InputBorder.none,
//                           prefixIcon: Icon(Icons.search, color: Colors.brown),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 20),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   PopupMenuButton<String>(
//                     icon: Icon(Icons.sort, color: Colors.brown),
//                     onSelected: (value) {
//                       setState(() {
//                         _selectedCategory = value;
//                       });
//                     },
//                     itemBuilder: (BuildContext context) {
//                       return <String>['All', 'Category1', 'Category2']
//                           .map<PopupMenuItem<String>>((String value) {
//                         return PopupMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList();
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _navigateToDetailPage(filteredList[index]),
//                       child: MemoryCard(
//                         memory: filteredList[index],
//                         onEdit: () {
//                           // Tambahkan logika edit
//                         },
//                         onDelete: () async {
//                           try {
//                             setState(() {
//                               isLoading = true; // Tampilkan loading indicator
//                             });

//                             bool success = await ds.removeId(
//                               token,
//                               project,
//                               'memory', // Nama koleksi
//                               appid,
//                               filteredList[index]
//                                   .id, // ID item yang ingin dihapus
//                             );

//                             if (success) {
//                               setState(() {
//                                 memoriesList
//                                     .removeAt(index); // Hapus dari daftar utama
//                                 filteredList.removeAt(
//                                     index); // Hapus dari daftar yang difilter
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text('Berhasil menghapus memory')),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text('Gagal menghapus memory')),
//                               );
//                             }
//                           } catch (e) {
//                             print('Error deleting memory: $e');
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text(
//                                       'Terjadi kesalahan saat menghapus memory')),
//                             );
//                           } finally {
//                             setState(() {
//                               isLoading =
//                                   false; // Sembunyikan loading indicator
//                             });
//                           }
//                         },
//                         onDownload: () {
//                           // Tambahkan logika unduh
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: Colors.brown,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.brown.withOpacity(0.4),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Icon(Icons.add, color: Colors.white),
//             ),
//             label: 'Tambah',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.brown,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class MemoryCard extends StatelessWidget {
//   final MemoryModel memory;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onDownload;

//   MemoryCard({
//     required this.memory,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onDownload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   memory.judul,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'Edit') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditScrapbookPage(
//                             key: key,
//                             templateIndex: int.parse(memory.template),
//                             initialTitle: memory.judul,
//                             initialDesc1: memory.desc1,
//                             initialDesc2: memory.desc2,
//                             initialDesc3: memory.desc3,
//                             initialDate: memory.tanggal,
//                             initialImagePaths: [
//                               memory.pict1,
//                               memory.pict2,
//                               memory.pict3
//                             ],
//                           ),
//                         ),
//                       );
//                     } else if (value == 'Hapus') {
//                       onDelete();
//                     } else if (value == 'Unduh') {
//                       onDownload();
//                     }
//                   },
//                   itemBuilder: (BuildContext context) =>
//                       <PopupMenuEntry<String>>[
//                     const PopupMenuItem<String>(
//                       value: 'Edit',
//                       child: Text('Edit'),
//                     ),
//                     const PopupMenuItem<String>(
//                       value: 'Hapus',
//                       child: Text('Hapus'),
//                     ),
//                     const PopupMenuItem<String>(
//                       value: 'Unduh',
//                       child: Text('Unduh'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               memory.tanggal,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '${memory.desc1}',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_stitch/Model/memory_model.dart';
import 'package:memory_stitch/Pages/edit_scarpbook.dart';
import 'package:memory_stitch/Pages/new_input_scarpbook.dart';
import 'package:memory_stitch/config.dart';
import 'package:memory_stitch/restapi.dart';
import 'detail_page.dart' as detail;
import 'new_scarpbook.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final searchKeyword = TextEditingController();
  bool isSearching = false;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _selectedIndex = 0;
  List<MemoryModel> memoriesList = [];
  final DataService ds = DataService();
  List<MemoryModel> filteredList = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';

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

//   void onDelete(String id) async {
//   bool success = await removeId(token, project, 'memory', appid, id);
//   if (success) {
//     // Jika berhasil, refresh daftar memory
//     fetchAllActivities();
//   } else {
//     // Tampilkan pesan kesalahan
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Failed to delete memory. Please try again.'),
//     ));
//   }
// }


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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    fetchAllActivities();
    searchKeyword.clear();
    filterActivities('');
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3EE),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B4513), Color(0xFF6B371F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MemoryStitch',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F3EE),
          image: DecorationImage(
            image: AssetImage('assets/scrapbook_bg.jpg'),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
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
                  hintText: 'Search memories...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.brown[300],
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.brown),
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.tune, color: Colors.brown),
                    onSelected: (value) {
                      setState(() => _selectedCategory = value);
                    },
                    itemBuilder: (context) => [
                      'All',
                      'Recent',
                      'Favorites',
                      'Albums'
                    ].map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return MemoryCard(
                          memory: filteredList[index],
                          onEdit: () {

                          },
                          onDelete: () async { 
                            try {
                              setState(() {
                                isLoading = true; 
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
                                      .removeAt(index); 
                                  filteredList.removeAt(
                                      index); 
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

                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewScrapbookPage()),
              );
            },
            backgroundColor: Color(0xFF8B4513),
            child: Icon(Icons.add, size: 32, color: Colors.white),
            elevation: 4,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 50),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF8B4513),
          unselectedItemColor: Colors.brown[300],
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDownload;

  const MemoryCard({
    required this.memory,
    required this.onEdit,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Debugging: Print memory details
            print('Navigating to DetailPage with memory: ${memory.judul}, ${memory.tanggal}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => detail.DetailPage(
                  title: memory.judul,
                  date: memory.tanggal,
                  texts: [memory.desc1, memory.desc2, memory.desc3],
                  imagePaths: [memory.pict1, memory.pict2, memory.pict3],
                  templateName: memory.template,
                  id: memory.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory.judul,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            memory.tanggal,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.brown),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'Edit':
                            onEdit();
                            break;
                          case 'Delete':
                            onDelete();
                            break;
                          case 'Download':
                            onDownload();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.brown, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Download',
                          child: Row(
                            children: [
                              Icon(Icons.download, color: Colors.brown, size: 20),
                              SizedBox(width: 8),
                              Text('Download'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    memory.desc1,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.brown[700],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}