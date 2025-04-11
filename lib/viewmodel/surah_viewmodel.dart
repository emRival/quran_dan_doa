import 'package:quran_dan_doa/model/surah_model.dart';
import 'package:quran_dan_doa/repository/quran_repo.dart';

class SurahViewModel {
  final QuranRepository _repository = QuranRepository();

  Future<List<Surah>> getListSurah() async => await _repository.getListSurah();
}
