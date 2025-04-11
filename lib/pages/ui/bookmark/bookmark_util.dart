import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quran_dan_doa/component/snackbar_item.dart';
import 'package:quran_dan_doa/model/ayah_model.dart';

void deleteBookmark(BuildContext context, String bookmarkKey) {
    final bookmarksBox = Hive.box('bookmarks_quran');
    bookmarksBox.delete(bookmarkKey);
      ScaffoldMessenger.of(context).showSnackBar(
        snack(
        text: 'Ayat ini sudah dihapus dari bookmark.',
        bg: Colors.red,
      ));
  }

void saveBookmark(BuildContext context, Ayat ayat, AyahModel surah) {
    final bookmarksBox = Hive.box('bookmarks_quran');
    final String bookmarkKey =
        '${surah.nomor}_${ayat.nomorAyat}'; // Kombinasi surat dan nomor ayat sebagai kunci

    // Check if the bookmark already exists
    bool bookmarkExists = bookmarksBox.containsKey(bookmarkKey);

    // Jika bookmark sudah ada, tampilkan pesan atau lakukan tindakan yang sesuai
    if (bookmarkExists) {
      // Tampilkan pesan atau lakukan tindakan yang sesuai
      ScaffoldMessenger.of(context).showSnackBar(
        snack(
        text: 'Ayat ini sudah disimpan sebagai bookmark.',
        bg: Colors.orange,
      ));
    } else {
      // Buat objek untuk disimpan sebagai bookmark
      final Map<String, dynamic> bookmarkData = {
        'id': surah.nomor,
        'nama_surat': surah.namaLatin,
        'arti': ayat.teksIndonesia,
        'nomor_ayat': ayat.nomorAyat,
        'arab': ayat.teksArab
      };

      // Simpan bookmark ke dalam database
      bookmarksBox.put(bookmarkKey, bookmarkData);

      // Tampilkan pesan sukses atau lakukan tindakan yang sesuai
      ScaffoldMessenger.of(context).showSnackBar(
          snack(text: 'Bookmark berhasil disimpan.', bg: Colors.green));

      // Jika ingin mengubah tampilan container menjadi ungu
      // dan menonaktifkan tombol "Simpan Bookmark", tambahkan logika di sini
      // Misalnya, ubah state atau berikan indikator visual kepada pengguna
    }
  }
