import 'package:hive/hive.dart';
import 'package:quran_dan_doa/model/ayah_model.dart';

void saveLastRead(AyahModel surah, int ayat) {
    final lastReadBox = Hive.box('last_read_quran');

    // Check if the data already exists
    if (lastReadBox.containsKey('last_read')) {
      // If it exists, get the current data
      final Map<dynamic, dynamic>? currentData = lastReadBox.get('last_read');

      // Update the relevant fields with the new data
      currentData?['id'] = surah.nomor;
      currentData?['nama_surah'] = surah.namaLatin;
      currentData?['nomor_ayat'] = ayat;

      // Put the updated data back into the box
      lastReadBox.put('last_read', currentData);
    } else {
      // If the data does not exist, create a new entry
      Map<dynamic, dynamic> lastReadData = {
        "id": surah.nomor,
        "nama_surah": surah.namaLatin,
        "nomor_ayat": ayat,
      };

      lastReadBox.put('last_read', lastReadData);
    }
  }