import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_dan_doa/pages/ui/bookmark/bookmark_util.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final GlobalKey _imageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBookmarkList(),
    );
  }

  // void _deleteBookmark(String bookmarkKey) {
  //   final bookmarksBox = Hive.box('bookmarks_quran');
  //   bookmarksBox.delete(bookmarkKey);
  // }

  Widget _buildBookmarkList() {
    final bookmarksBox = Hive.box('bookmarks_quran');
    final List<String> bookmarkKeys = bookmarksBox.keys.cast<String>().toList();

    if (bookmarkKeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_add_outlined,
              color: Colors.grey.withOpacity(0.1),
              size: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Belum ada bookmark',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey.withOpacity(0.1),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    // Kelompokkan daftar bookmark berdasarkan ID surah
    final Map<int, List<String>> groupedBookmarks = {};
    bookmarkKeys.forEach((bookmarkKey) {
      final dynamic bookmarkData = bookmarksBox.get(bookmarkKey);
      final int surahId = bookmarkData['id'];
      if (!groupedBookmarks.containsKey(surahId)) {
        groupedBookmarks[surahId] = [];
      }
      groupedBookmarks[surahId]!.add(bookmarkKey);
    });

    print(groupedBookmarks);

    return ListView.builder(
      itemCount: groupedBookmarks.length,
      itemBuilder: (context, index) {
        final int surahId = groupedBookmarks.keys.elementAt(index);
        final List<String> surahBookmarks = groupedBookmarks[surahId]!;
        print(surahBookmarks.first);
        final dynamic firstBookmarkData =
            bookmarksBox.get(surahBookmarks.first);
        print(firstBookmarkData);

        if (firstBookmarkData != null) {
          final String surah = firstBookmarkData['nama_surat']
              .toString(); // Ubah tipe data int menjadi String
          return ExpansionTile(
            title: Text('Surat $surah'),
            children: surahBookmarks.map((bookmarkKey) {
              final dynamic bookmarkData = bookmarksBox.get(bookmarkKey);
              final int nomorAyat = bookmarkData['nomor_ayat'];
              final String ayatText = bookmarkData['arti'];
              final String arabText = bookmarkData['arab'];

              return ListTile(
                trailing: IconButton(
                  onPressed: () {
                    deleteBookmark(context,bookmarkKey);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.bookmark,
                    color: Colors.amber,
                  ),
                ),
                title: Text(
                    '$surah: $nomorAyat'), // Ubah tipe data int menjadi String
                subtitle: Text(ayatText),
                onTap: () {
                  _showBookmarkDialog(
                    context,
                    surah,
                    nomorAyat,
                    ayatText,
                    arabText,
                  );
                },
              );
            }).toList(),
          );
        } else {
          return SizedBox(); // Return empty SizedBox if bookmarkData is null
        }
      },
    );
  }

  void _showBookmarkDialog(BuildContext context, String surah, int nomorAyat,
      String ayatText, String arabText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          actions: [
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.ios_share,
                  color: Colors.black,
                ),
                onPressed: () {
                  _shareBookmark(context);
                },
              ),
            ),
          ],
          content: Stack(
            children: [
              RepaintBoundary(
                key: _imageKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    // height: 0,
                    width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '$surah : $nomorAyat',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            arabText,
                            style: GoogleFonts.amiriQuran(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              height: 2.7,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            ayatText,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.green,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rival.dev',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.grey.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pembaruan pada method _shareBookmark untuk menghilangkan parameter GlobalKey
  Future<void> _shareBookmark(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/image.png';
      File(imagePath)
          .writeAsBytesSync(pngBytes); // Menyimpan gambar sebagai file

      await Share.shareXFiles([XFile(imagePath)]);
    } catch (e) {
      print('Error sharing bookmark: $e');
    }
  }
}
