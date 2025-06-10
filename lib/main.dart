import 'package:climafy/quotes/quote_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuoteHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
