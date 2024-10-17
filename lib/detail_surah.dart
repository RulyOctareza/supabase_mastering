import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart'; // Untuk share ayat
import 'package:flutter/services.dart'; // Untuk copy paste
import 'package:fluttertoast/fluttertoast.dart'; // Untuk notifikasi kecil (toast)

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen(
      {super.key, required this.surahNumber, required this.surahName});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List? ayatData;
  bool isDarkMode = false; // Untuk toggle tema gelap/terang
  bool isBookmarked = false; // Simpan status bookmark
  final String baseUrl = 'http://api.alquran.cloud/v1/surah'; // Base URL API

  @override
  void initState() {
    super.initState();
    getSurahDetail(widget.surahNumber);
  }

  // Fungsi untuk mengambil detail surat dari API
  Future<void> getSurahDetail(int surahNumber) async {
    var res = await http.get(Uri.parse('$baseUrl/$surahNumber'));
    if (res.statusCode == 200) {
      setState(() {
        var content = json.decode(res.body);
        ayatData = content['data']['ayahs'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk copy ayat dan terjemahannya
  void copyAyat(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
        msg: 'Ayat berhasil disalin', toastLength: Toast.LENGTH_SHORT);
  }

  // Fungsi untuk share ayat
  void shareAyat(String ayat, String translation, int ayatNumber) {
    Share.share(
        'Surah ${widget.surahName}, Ayat $ayatNumber\n\n$ayat\n\nTerjemahan: $translation');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(), // Toggle tema
      home: Scaffold(
        appBar: AppBar(
          title: Text('${widget.surahName} (${widget.surahNumber})'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            // IconButton(
            //   icon: Icon(
            //     isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            //     color: isBookmarked ? Colors.amber : Colors.white,
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       isBookmarked = !isBookmarked; // Toggle status bookmark
            //       if (isBookmarked) {
            //         BookmarkManager.addBookmark(widget.surahNumber,
            //             widget.surahNumber); // Simpan bookmark
            //       } else {
            //         BookmarkManager.removeBookmark(widget.surahNumber,
            //             widget.surahNumber); // Hapus bookmark
            //       }
            //     });
            //   },
            // ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode; // Toggle mode terang/gelap
                });
              },
            ),
          ],
        ),
        body: ayatData == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ayatData?.length ?? 0,
                itemBuilder: (context, index) {
                  var ayat = ayatData![index]['text'];
                  //   var translation = ayatData![index]['translation'];
                  //   var audioUrl = ayatData![index]['audio'];
                  var ayatNumber = ayatData![index]['numberInSurah'];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Ayat $ayatNumber',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ayat,
                            style: GoogleFonts.notoNaskhArabic(
                                textStyle: const TextStyle(fontSize: 28)),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 10),
                          // Text('Terjemahan: $translation',
                          //     style:
                          //         const TextStyle(fontStyle: FontStyle.italic)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill),
                                onPressed: () {
                                  // Implementasi pemutar audio
                                  // Contoh untuk memutar audio bisa menggunakan pustaka `audioplayers`
                                },
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.bookmark),
                              //   onPressed: () {
                              //     setState(() {
                              //       isBookmarked = !isBookmarked;
                              //       if (isBookmarked) {
                              //         BookmarkManager.addBookmark(
                              //             widget.surahNumber,
                              //             ayatNumber); // Simpan bookmark
                              //       } else {
                              //         BookmarkManager.removeBookmark(
                              //             widget.surahNumber,
                              //             ayatNumber); // Hapus bookmark
                              //       }
                              //     });
                              //   },
                              //      ),
                              // IconButton(
                              //   icon: const Icon(Icons.copy),
                              //   onPressed: () => copyAyat(
                              //       'Ayat $ayatNumber: $ayat\nTerjemahan: $translation'),
                              // ),
                              // IconButton(
                              //   icon: const Icon(Icons.share),
                              //   onPressed: () =>
                              //       shareAyat(ayat, translation, ayatNumber),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
