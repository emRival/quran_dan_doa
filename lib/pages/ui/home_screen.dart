import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:quran_dan_doa/pages/ui/bookmark/bookmark_page.dart';
import 'package:quran_dan_doa/pages/ui/main_page.dart';

import 'package:quran_dan_doa/theme.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        // Return Quran page
        return const QuranPage();
      case 1:
        // Return Doa page
        return const Center(child: Text('Doa Page'));
      case 2:
        // Return Bookmark page
        return const BookmarkPage();
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  CurvedNavigationBar _bottomNavigationBar() => CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.transparent,
        color: primary.withOpacity(0.7),
        animationCurve: Curves.easeInOutSine,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          SvgPicture.asset(
            'assets/svg/quran_icon.svg',
            color: Colors.white,
            height: 25,
          ),
          SvgPicture.asset(
            'assets/svg/doa_icon.svg',
            color: Colors.white,
            height: 25,
          ),
          SvgPicture.asset(
            'assets/svg/bookmark_icon.svg',
            color: Colors.white,
            height: 25,
          ),
        ],
      );
}
