import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_dan_doa/component/tab_item.dart';
import 'package:quran_dan_doa/pages/ui/bookmark/bookmark_page.dart';
import 'package:quran_dan_doa/pages/ui/tab_bar/quran/detail_screen.dart';
import 'package:quran_dan_doa/pages/ui/tab_bar/quran/surah_tab.dart';
import 'package:quran_dan_doa/theme.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late String _namaSurat = 'Yuk Baca Quran';
  late String _nomorSurat = '-';
  late String _idSurat = '';

  late Box<dynamic> _lastReadBox;
  late Stream<BoxEvent> _lastReadStream;

  @override
  void initState() {
    super.initState();
    _lastReadBox = Hive.box('last_read_quran');
    _lastReadStream = _lastReadBox.watch(key: 'last_read');
    _loadLastReadData();
  }

  void _loadLastReadData() {
    final lastReadData = _lastReadBox.get('last_read', defaultValue: null);
    if (lastReadData != null && lastReadData is Map<dynamic, dynamic>) {
      _namaSurat = lastReadData['nama_surah'].toString();
      _nomorSurat = lastReadData['nomor_ayat'].toString();
      _idSurat = lastReadData['id'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  AppBar _appBar() => AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      onPressed: () {},
      icon: SvgPicture.asset('assets/svg/menu_icon.svg'),
    ),
    title: Text(
      'Quran App',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svg/search_icon.svg'),
      ),
    ],
  );

  Widget _body() => DefaultTabController(
    length: 3,
    child: NestedScrollView(
      headerSliverBuilder:
          (BuildContext context, bool innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: _salam()),
            SliverAppBar(
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              shape: Border(
                bottom: BorderSide(
                  width: 3,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: TabBar(
                  labelColor: primary,
                  indicatorColor: primary,
                  indicatorWeight: 3,
                  tabs: [
                    itemTab(label: "Surah"),
                    itemTab(label: "Bookmark"),
                  ],
                ),
              ),
            ),
          ],
      body: TabBarView(children: [TabSurah(), BookmarkPage()]),
    ),
  );

  Widget _salam() => StreamBuilder<BoxEvent>(
    stream: _lastReadStream,
    builder: (context, snapshot) {
      _loadLastReadData(); // Reload data when box changes
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assalamualikum',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rival',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double containerWidth = MediaQuery.of(context).size.width;
                    return Container(
                      height: 150,
                      width: containerWidth,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffdf98fa), Color(0xff9055ff)],
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          print(_idSurat);
                          if (_idSurat.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              DetailScreen1.routeName,
                              arguments: {
                                'idSurah': _idSurat,
                                'nomorAyat': _nomorSurat,
                              },
                            );
                          } else {
                            _showDialog();
                          }
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                'assets/svg/quran_banner.svg',
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
                                        "Last Read",
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
                                    _namaSurat,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ayat No: $_nomorSurat",
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
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yuk Ngaji', textAlign: TextAlign.center),
          content: Text('Jangan Scroll Tiktok Terus :)'),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }
}
