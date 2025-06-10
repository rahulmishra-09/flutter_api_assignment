import 'dart:async';
import 'package:climafy/climafy/home_data.dart';
import 'package:climafy/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeData()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lightGreen, darkGreen],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CLIMAFY',
                style: GoogleFonts.merienda(
                  fontWeight: FontWeight.w900,
                  color: metalicSilver,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 20),
              SpinKitSpinningLines(color: metalicSilver),
            ],
          ),
        ),
      ),
    );
  }
}
