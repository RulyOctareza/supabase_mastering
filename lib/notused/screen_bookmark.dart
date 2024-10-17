import 'package:first_app/detail_surah.dart';
import 'package:flutter/material.dart';
import 'bookmark_manager.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  // Memuat bookmark yang tersimpan
  Future<void> loadBookmarks() async {
    List<String> loadedBookmarks = await BookmarkManager.getBookmarks();
    setState(() {
      bookmarks = loadedBookmarks;
    });
  }

  // Parse bookmark string ke nomor surat dan ayat
  Map<String, int> parseBookmark(String bookmark) {
    List<String> parts = bookmark.split(':');
    return {
      'surahNumber': int.parse(parts[0]),
      'ayatNumber': int.parse(parts[1]),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmark Saya')),
      body: bookmarks.isEmpty
          ? const Center(child: Text('Belum ada ayat yang dibookmark'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                Map<String, int> bookmarkData = parseBookmark(bookmarks[index]);
                int surahNumber = bookmarkData['surahNumber']!;
                int ayatNumber = bookmarkData['ayatNumber']!;

                return ListTile(
                  title: Text('Surah $surahNumber, Ayat $ayatNumber'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        BookmarkManager.removeBookmark(surahNumber, ayatNumber);
                        bookmarks.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
                    // Navigasi ke detail surat ketika bookmark diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(
                          surahNumber: surahNumber,
                          surahName:
                              'Surah $surahNumber', // Sesuaikan dengan API surat
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
