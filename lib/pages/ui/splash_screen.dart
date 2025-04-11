import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_dan_doa/pages/ui/home_screen.dart';
import 'package:quran_dan_doa/theme.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = 'splash_screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Quran App",
                style: GoogleFonts.poppins(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Learn Quran and\nRecite once everyday",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: secondary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 450,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SvgPicture.asset('assets/svg/splash.svg'),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: -20,
                    child: Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 65, vertical: 12),
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
