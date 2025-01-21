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
import 'package:intl/intl.dart';

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

  bool _isAscending = true; // Sorting state

  int _selectedIndex = 0;
  List<MemoryModel> memoriesList = [];
  final DataService ds = DataService();
  List<MemoryModel> filteredList = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  Future<void> fetchAllActivities() async {
    try {
      final response = await ds.selectAll(token, project, 'memory', appid);
      final List data = jsonDecode(response);
      memoriesList = data.map((e) => MemoryModel.fromJson(e)).toList();
      filteredList = memoriesList; // Initialize filteredList
      sortMemories(); // Sort the memoriesList by date
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void sortMemories() {
  //   setState(() {
  //     if (_isAscending) {
  //       filteredList.sort((a, b) => DateTime.parse(a.tanggal).compareTo(DateTime.parse(b.tanggal)));
  //     } else {
  //       filteredList.sort((a, b) => DateTime.parse(b.tanggal).compareTo(DateTime.parse(a.tanggal)));
  //     }
  //   });
  // }

  void sortMemories() {
    setState(() {
      memoriesList.sort((a, b) {
        try {
          if (a.tanggal.isEmpty || b.tanggal.isEmpty) {
            return 0;
          }
          DateTime dateA = DateFormat('dd-MMM-yyyy').parse(a.tanggal);
          DateTime dateB = DateFormat('dd-MMM-yyyy').parse(b.tanggal);
          return _isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
        } catch (e) {
          print('Invalid date format: ${a.tanggal} or ${b.tanggal}');
          return 0;
        }
      });
      _isAscending = !_isAscending; // Toggle sorting direction
    });
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
      sortMemories(); // Re-sort after filtering
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
      suffixIcon: IconButton(
        icon: Icon(Icons.sort, color: Colors.brown),
        onPressed: () {
          sortMemories(); // Fungsi untuk sorting
        },
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
                          onEdit: () {},
                          onDelete: () async {
                            // Handle delete logic
                          },
                          onDownload: () {},
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
                              Icon(Icons.download,
                                  color: Colors.brown, size: 20),
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
