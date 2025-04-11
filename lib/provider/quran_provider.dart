import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_dan_doa/model/ayah_model.dart';
import 'package:quran_dan_doa/viewmodel/ayah_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ResultState { loading, noData, hasData, error }

class QuranProvider extends ChangeNotifier {
  final AyahViewModel ayahViewModel = AyahViewModel();
  final String id_surah;
  late bool _latinCheck;
  late bool _terjemahCheck;
  late double _arabicFontSize;
  late String _selectedAudioSource;
  static const String _settingsKey = 'quran_settings';



  QuranProvider({required this.id_surah}) {
    _loadSettings();
    _fetchAllAyah(id: id_surah);
  }

  late AyahModel _ayahsResult;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  double get arabicFontSize => _arabicFontSize;

  bool get latinCheck => _latinCheck;
  bool get terjemahCheck => _terjemahCheck;

  String get audioSources => _selectedAudioSource;
  Map<String, String> get audioListSources => _audioSources;

  AyahModel get result => _ayahsResult;


  List<Ayat>? get ayat => _ayahsResult.ayat;

  ResultState get state => _state;

  ConnectionState _connectionState = ConnectionState.none;

  ConnectionState get connectionState => _connectionState;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      final settings = jsonDecode(settingsJson);
      _latinCheck = settings['latinCheck'] ?? true;
      _terjemahCheck = settings['terjemahCheck'] ?? true;
      _arabicFontSize = settings['arabicFontSize'] ?? 20.0;
      _selectedAudioSource = settings['selectedAudioSource'] ?? "01";
    } else {
      _latinCheck = true;
      _terjemahCheck = true;
      _arabicFontSize = 20.0;
      _selectedAudioSource = "01";
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = {
      'latinCheck': _latinCheck,
      'terjemahCheck': _terjemahCheck,
      'arabicFontSize': _arabicFontSize,
      'selectedAudioSource': _selectedAudioSource
    };
    await prefs.setString(_settingsKey, jsonEncode(settings));
    notifyListeners();
  }

  Future<void> updateLatinCheck(bool newValue) async {
    _latinCheck = newValue;
    await _saveSettings();
  }

  Future<void> updateTerjemahCheck(bool newValue) async {
    _terjemahCheck = newValue;
    await _saveSettings();
  }

  Future<void> setArabicFontSize(double fontSize) async {
    _arabicFontSize = fontSize;
    await _saveSettings();
  }

  Future<void> updateSelectedAudio(String audio) async {
    _selectedAudioSource = audio;
    await _saveSettings();
  }


  double onSettingChanged() {
    notifyListeners();
    return _arabicFontSize;
  }

  Future<void> _fetchAllAyah({required String id}) async {
    try {
      _connectionState = ConnectionState.waiting;
      notifyListeners();
      final ayah = await ayahViewModel.getListAyah(id);
      if (ayah.ayat!.isEmpty) {
        _connectionState = ConnectionState.done;
        _state = ResultState.noData;
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _connectionState = ConnectionState.done;
        _state = ResultState.hasData;
        notifyListeners();
        _ayahsResult = ayah;
      }
    } catch (e) {
      _connectionState = ConnectionState.done;
      _state = ResultState.error;
      notifyListeners();
      _message = 'Error --> $e';
    }
  }

  void onRetry() {
    _fetchAllAyah(id: id_surah);
  }

  String? getAudioFullLink() {
    switch (_selectedAudioSource) {
      case '01':
        return _ayahsResult.audioFull?.s01?.toString();
      case '02':
        return _ayahsResult.audioFull?.s02?.toString();
      case '03':
        return _ayahsResult.audioFull?.s03?.toString();
      case '04':
        return _ayahsResult.audioFull?.s04?.toString();
      case '05':
        return _ayahsResult.audioFull?.s05?.toString();
      // Add cases for other audio sources as needed
      default:
        // Handle the default case, maybe set link to a default value or show an error message
        return null;
    }
  }

  String? getAudioAyatLink(Ayat ayat) {
    switch (_selectedAudioSource) {
      case '01':
        return ayat.audio!.s01.toString();
      case '02':
        return ayat.audio!.s02.toString();
      case '03':
        return ayat.audio!.s03?.toString();
      case '04':
        return ayat.audio!.s04?.toString();
      case '05':
        return ayat.audio!.s05?.toString();
      // Add cases for other audio sources as needed
      default:
        // Handle the default case, maybe set link to a default value or show an error message
        return null;
    }
  }

  Future<void> setupAudioPlayer(
      {required AudioPlayer player, required String link}) async {
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
      print("A Stream Error Occurred: $e");
    });
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(link)));
    } catch (e) {
      print("Error Loading Audio Source: $e");
    }
  }

  final Map<String, String> _audioSources = {
    "Abdullah Al-Juhany": "01",
    "Abdul Muhsin Al-Qasim": "02",
    "Abdurrahman as-Sudais": "03",
    "Ibrahim Al-Dossari": "04",
    "Misyari Rasyid Al-Afasi": "05"
  };










}



