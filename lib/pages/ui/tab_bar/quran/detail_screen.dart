import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:quran_dan_doa/model/ayah_model.dart';
import 'package:quran_dan_doa/pages/ui/tab_bar/quran/DetailScreenRetry.dart';
import 'package:quran_dan_doa/pages/ui/bookmark/bookmark_util.dart';
import 'package:quran_dan_doa/pages/ui/tab_bar/quran/save_last_read.dart';
import 'package:quran_dan_doa/provider/quran_provider.dart';

class DetailScreen1 extends StatefulWidget {
  static const routeName = 'detail_screen';
  final String idSurah;
  final String? nomorAyat;
  final Key? refreshKey; // Parameter tambahan untuk memuat ulang halaman

  const DetailScreen1({required this.idSurah, this.refreshKey, this.nomorAyat})
    : super(key: refreshKey);

  @override
  State<DetailScreen1> createState() => _DetailScreen1State();
}

class _DetailScreen1State extends State<DetailScreen1> {
  late final AudioPlayer _player;
  late final AudioPlayer _player2;
  late bool _isAudioLoaded;
  late bool _isAudioLoaded2;

  @override
  void initState() {
    super.initState();
    // _arrfontSize = 20.0;
    // _selectedAudioSource = "01";
    // _loadData(); // Panggil _loadData() di sini
    _player = AudioPlayer();
    _player2 = AudioPlayer();
    _isAudioLoaded = false;
    _isAudioLoaded2 = false;
  }

  @override
  void dispose() {
    _player.dispose();
    _player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuranProvider>(
      create: (_) => QuranProvider(id_surah: widget.idSurah),
      child: Scaffold(appBar: _appBar(), body: SafeArea(child: _buildBody())),
    );
  }

  AppBar _appBar() => AppBar(
    elevation: 0,
    title: Consumer<QuranProvider>(
      builder: (context, state, _) {
        if (state.connectionState == ConnectionState.waiting) {
          return const Icon(Icons.all_inclusive_rounded);
        } else if (state.state == ResultState.hasData) {
          final ayahModel = state.result;
          return Text(
            ayahModel.nama.toString(),
            style: GoogleFonts.amiriQuran(),
          );
        } else {
          return const Text('Detail Screen');
        }
      },
    ),
    centerTitle: true,
    actions: [setting()],
  );

  Widget setting() {
    return Consumer<QuranProvider>(
      builder: (context, state, _) {
        return IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Font Size: ${state.arabicFontSize.toInt()}"),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Icon(Icons.format_size, size: 18),
                              Expanded(
                                child: Slider(
                                  value: state.arabicFontSize,
                                  min: 16.0,
                                  max: 30.0,
                                  divisions: 100,
                                  onChanged: (double value) {
                                    setState(() {
                                      state.setArabicFontSize(value);
                                    });
                                  },
                                ),
                              ),
                              const Icon(Icons.format_size, size: 25),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Latin'),
                                  value: state.latinCheck,
                                  onChanged: (newValue) {
                                    setState(() {
                                      state.updateLatinCheck(newValue!);
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Terjemah'),
                                  value: state.terjemahCheck,
                                  onChanged: (newValue) {
                                    setState(() {
                                      state.updateTerjemahCheck(newValue!);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: state.audioSources,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  state.updateSelectedAudio(newValue);
                                });
                              }
                            },
                            items:
                                state.audioListSources.keys
                                    .map<DropdownMenuItem<String>>((
                                      String key,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: state.audioListSources[key],
                                        child: Text(key),
                                      );
                                    })
                                    .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.settings, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<QuranProvider>(
      builder: (context, state, _) {
        if (state.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.error) {
          return DetailScreenRetry(onRetry: state.onRetry);
        } else if (state.state == ResultState.hasData) {
          return Column(
            children: [
              Padding(padding: const EdgeInsets.all(10.0), child: _banner()),
              Expanded(child: _buildListView()),
            ],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildListView() {
    return Consumer<QuranProvider>(
      builder: (context, state, _) {
        final scrollController = ScrollController();

        // Scroll to the specified Ayat when the widget is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.ayat != null && widget.nomorAyat != null) {
            final targetIndex = int.parse(widget.nomorAyat!) - 1;
            if (targetIndex >= 0 && targetIndex < state.ayat!.length) {
              final offset = state.ayat!
            .sublist(0, targetIndex)
            .map((ayat) => ayat.teksArab!.length * 2.0)
            .reduce((value, element) => value + element);
              scrollController.jumpTo(offset);
            }
          }
        });

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            final ayahModel = state.result;
            final bookmarksBox = Hive.box('bookmarks_quran');
            final String bookmarkKey =
                '${ayahModel.nomor}_${state.ayat?[index].nomorAyat}';
            final bool bookmarkExists = bookmarksBox.containsKey(bookmarkKey);

            return InkWell(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    late String linkAudio;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text('Save Last Read'),
                          onTap: () {
                            saveLastRead(
                              ayahModel,
                              ayahModel.ayat![index].nomorAyat!,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading:
                              bookmarkExists
                                  ? const Icon(Icons.bookmark_remove)
                                  : const Icon(Icons.bookmark_add),
                          title:
                              bookmarkExists
                                  ? const Text('Delete Bookmark')
                                  : const Text('Save Bookmark'),
                          onTap:
                              bookmarkExists
                                  ? () {
                                    deleteBookmark(context, bookmarkKey);
                                    Navigator.of(context).pop();
                                  }
                                  : () {
                                    saveBookmark(
                                      context,
                                      state.ayat![index],
                                      ayahModel,
                                    );
                                    Navigator.of(context).pop();
                                  },
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () async {
                                linkAudio =
                                    state.getAudioAyatLink(state.ayat![index])!;

                                if (state.connectionState ==
                                    ConnectivityResult.none) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Tidak ada koneksi internet.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (_player.playing) {
                                  _player.pause();
                                }

                                if (!_isAudioLoaded2) {
                                  state.setupAudioPlayer(
                                    player: _player2,
                                    link: linkAudio,
                                  );

                                  _isAudioLoaded2 = true;
                                }

                                if (_player2.playing) {
                                  _player2.pause();
                                } else {
                                  _player2.play();
                                }
                              },
                              icon: StreamBuilder<PlayerState>(
                                stream: _player2.playerStateStream,
                                builder: (context, snapshot) {
                                  final processingState =
                                      snapshot.data?.processingState;
                                  final playing = snapshot.data?.playing;
                                  if (processingState ==
                                          ProcessingState.loading ||
                                      processingState ==
                                          ProcessingState.buffering) {
                                    return const SizedBox(
                                      width: 24.0,
                                      height: 24.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        color: Color.fromARGB(255, 183, 8, 171),
                                      ),
                                    );
                                  } else if (playing != true) {
                                    return const Icon(
                                      Icons.play_arrow,
                                      color: Color.fromARGB(255, 183, 8, 171),
                                    );
                                  } else if (processingState !=
                                          ProcessingState.completed &&
                                      _isAudioLoaded2 == true) {
                                    return const Icon(
                                      Icons.pause,
                                      color: Color.fromARGB(255, 183, 8, 171),
                                    );
                                  } else {
                                    _isAudioLoaded2 = false;
                                    return const Icon(
                                      Icons.replay,
                                      color: Color.fromARGB(255, 183, 8, 171),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ), // Spasi antara IconButton dan Text
                            const Text(
                              "Play Audio",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                color: _getColorForLastReadItem(state.ayat![index], ayahModel),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildNumberIcon(bookmarkExists, state.ayat![index]),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            state.ayat![index].teksArab.toString(),
                            style: GoogleFonts.amiriQuran(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: state.arabicFontSize.toDouble(),
                              height: 2.5,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 15),
                          state.latinCheck
                              ? _buildLatinText(state.ayat![index])
                              : const SizedBox.shrink(),
                          state.terjemahCheck
                              ? _buildTerjemahText(state.ayat![index])
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder:
              (context, index) =>
                  Divider(color: Colors.grey.withOpacity(0.1), height: 1),
          itemCount: state.ayat!.length,
        );
      },
    );
  }

  Color _getColorForLastReadItem(Ayat ayat, AyahModel surah) {
    final lastReadBox = Hive.box('last_read_quran');
    final int? lastReadSurahId = lastReadBox.get('last_read')?['id'];
    final int? lastReadAyatNumber = lastReadBox.get('last_read')?['nomor_ayat'];
    final bool isLastRead =
        lastReadSurahId == surah.nomor && lastReadAyatNumber == ayat.nomorAyat;

    return isLastRead ? Colors.yellow : Colors.transparent;
  }

  Widget _buildNumberIcon(bool bookmarkExists, Ayat ayat) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/svg/nomor_surah.svg',
          color: bookmarkExists ? Colors.green : Colors.purple,
        ),
        SizedBox(
          height: 36,
          width: 36,
          child: Center(
            child: Text(
              ayat.nomorAyat.toString(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLatinText(Ayat ayat) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topLeft,
      child: Text(
        ayat.teksLatin.toString(),
        style: GoogleFonts.amiri(
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.w300,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildTerjemahText(Ayat ayat) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topLeft,
      child: Text(
        ayat.teksIndonesia.toString(),
        textAlign: TextAlign.justify,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _banner() {
    return Consumer<QuranProvider>(
      builder: (context, state, _) {
        final ayat = state.result;
        final String? link = state.getAudioFullLink();
        return Stack(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffdf98fa), Color(0xff9055ff)],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              bottom: 0,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff9055ff), Color(0xffdf98fa)],
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      // var connectivityResult =
                      //     await Connectivity().checkConnectivity();

                      if (state.connectionState == ConnectivityResult.none) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        // Tampilkan Snackbar jika tidak ada koneksi internet
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak ada koneksi internet.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_player2.playing) {
                        _player2.pause();
                      }

                      // Jika audio belum dimuat, muat audio dan set _isAudioLoaded menjadi true
                      if (!_isAudioLoaded) {
                        state.setupAudioPlayer(player: _player, link: link!);
                        _isAudioLoaded = true;
                      }

                      if (_player.playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                    icon: StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final processingState = snapshot.data?.processingState;
                        final playing = snapshot.data?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (playing != true) {
                          return const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          );
                        } else if (processingState !=
                                ProcessingState.completed &&
                            _isAudioLoaded == true) {
                          return const Icon(
                            Icons.pause,
                            size: 30,
                            color: Colors.white,
                          );
                        } else {
                          _isAudioLoaded = false;
                          return const Icon(
                            Icons.replay,
                            size: 30,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/svg/book.svg'),
                      const SizedBox(width: 10),
                      Text(
                        ayat.nama.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    ayat.namaLatin.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ayat.arti.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
