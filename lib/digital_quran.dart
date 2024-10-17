import 'dart:convert';
import 'package:first_app/detail_surah.dart';
import 'package:first_app/notused/screen_bookmark.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DigitalQuran extends StatefulWidget {
  const DigitalQuran({super.key});

  @override
  DigitalQuranState createState() => DigitalQuranState();
}

class DigitalQuranState extends State<DigitalQuran> {
  final String url = 'http://api.alquran.cloud/v1/surah'; // URL API baru
  List? data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    var res =
        await http.get(Uri.parse(url), headers: {'accept': 'application/json'});

    if (res.statusCode == 200) {
      setState(() {
        var content = json.decode(res.body);
        // Mengambil data dari kunci 'data'
        if (content != null && content['data'] != null) {
          data = content['data'];
        } else {
          throw Exception('Invalid JSON structure');
        }
      });
      return 'success!';
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Quran',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Digital Quran',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookmarkScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Text(
                              data![index]['number'].toString(), // Nomor Surah
                              style: const TextStyle(fontSize: 30.0),
                            ),
                            title: Text(
                              data![index]['name'], // Nama Surah
                              style: const TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: Image.asset(
                              data![index]['revelationType'] == 'Meccan'
                                  ? 'assets/mekah.jpg'
                                  : 'assets/madinah.png',
                              width: 32.0,
                              height: 32.0,
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Text(
                                      'Terjemahan: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data![index]['englishNameTranslation'],
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    const Text(
                                      'Jumlah Ayat: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(data![index]['numberOfAyahs']
                                        .toString()), // Jumlah Ayat
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    const Text(
                                      'Diturunkan di: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(data![index]
                                        ['revelationType']), // Tipe Wahyu
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ButtonTheme(
                            child: OverflowBar(
                              children: <Widget>[
                                ElevatedButton(
                                  child: const Text('LIHAT DETAIL'),
                                  onPressed: () {
                                    // Mengambil nomor dan nama surat dari data API
                                    int surahNumber = data![index]['number'];
                                    String surahName = data![index]['name'];

                                    // Navigasi ke halaman detail surat
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SurahDetailScreen(
                                          surahNumber: surahNumber,
                                          surahName: surahName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // ElevatedButton(
                                //   child: const Text('DENGARKAN'),
                                //   onPressed: () {/* ... */},
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
