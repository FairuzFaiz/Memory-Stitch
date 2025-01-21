import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memory_stitch/Model/memory_model.dart';
import 'package:memory_stitch/Pages/edit_scarpbook.dart';
import 'package:memory_stitch/config.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String date;
  final List<String> texts;
  final List<String> imagePaths;
  final String templateName;
  final String id;

  const DetailPage({
    Key? key,
    required this.title,
    required this.date,
    required this.texts,
    required this.imagePaths,
    required this.templateName,
    required this.id,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String title = '';
  String date = '';
  List<String> texts = [];
  List<String> imagePaths = [];
  String templateName = '';
  String id = '';

  @override
void initState() {
  super.initState();
  title = widget.title;
  date = widget.date;
  texts = widget.texts;
  imagePaths = widget.imagePaths;
  templateName = widget.templateName;
  id = widget.id;
  fetchDetailData(); // Fetch data tambahan jika diperlukan
}

  Future<void> fetchDetailData() async {
  try {
    final response = await http.get(
      Uri.parse('https://io.etter.cloud/v4/get_id?id=${widget.id}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.containsKey('judul')) {
        setState(() {
          title = data['judul'];
          date = data['tanggal'];
          texts = [data['desc1'], data['desc2'], data['desc3']];
          imagePaths = [data['pict1'], data['pict2'], data['pict3']];
          templateName = data['template'];
        });
      } else {
        print('Unexpected data format: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected data format received')),
        );
      }
    } else {
      
    }
  } catch (e) {
    print('Error fetching details: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching details: $e')),
    );
  }
}



  Future<bool> updateField(
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid,
      String id) async {
    String uri = 'https://io.etter.cloud/v4/update_id';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid,
        'id': id
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = 'assets/$templateName';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Scrapbook'),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScrapbookPage(
                    memory: MemoryModel(
                      id: id,
                      judul: title,
                      desc1: texts[0],
                      desc2: texts[1],
                      desc3: texts[2],
                      pict1: imagePaths[0],
                      pict2: imagePaths[1],
                      pict3: imagePaths[2],
                      tanggal: date,
                      template: templateName,
                    ),
                    templateIndex: templateName.indexOf(templateName),
                  ),
                ),
              );
              if (result = true) {
                fetchDetailData();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Tambahkan logika untuk download scrapbook (misalnya, membuat PDF)
            },
          ),
        ],
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
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.5),
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
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
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
                            child: Stack(
                              children: [
                                Container(
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
                              ],
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 220,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  texts[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
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
