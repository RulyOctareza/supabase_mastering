import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String bookmarksKey = 'bookmarked_ayahs';

  // Tambah bookmark (ayat atau surah)
  static Future<void> addBookmark(int surahNumber, int ayatNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarksKey) ?? [];

    String bookmark = '$surahNumber:$ayatNumber';
    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await prefs.setStringList(bookmarksKey, bookmarks);
    }
  }

  // Hapus bookmark
  static Future<void> removeBookmark(int surahNumber, int ayatNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarksKey) ?? [];

    String bookmark = '$surahNumber:$ayatNumber';
    bookmarks.remove(bookmark);
    await prefs.setStringList(bookmarksKey, bookmarks);
  }

  // Ambil semua bookmark
  static Future<List<String>> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(bookmarksKey) ?? [];
  }

  // Cek apakah ayat/surat sudah dibookmark
  static Future<bool> isBookmarked(int surahNumber, int ayatNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(bookmarksKey) ?? [];
    return bookmarks.contains('$surahNumber:$ayatNumber');
  }
}
