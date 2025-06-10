import 'dart:convert';

import 'package:climafy/climafy/home_data.dart';
import 'package:climafy/climafy/location.dart';
import 'package:climafy/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  var apiKey = '05bbfb9a7a452f6f3187723b38621d0e';
  final apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=05bbfb9a7a452f6f3187723b38621d0e';

  @override
  void initState() {
    if (mounted) {
      getLocation();
    }
    super.initState();
  }

  void getLocation() async {
    await location.getCurrentLocation();

    double? lat = location.latitude!;
    double? lon = location.longitude!;

    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomeData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: metalicSilver,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          'Climafy',
          style: GoogleFonts.merienda(
            fontWeight: FontWeight.w900,
            color: lightSilver,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: getLocation, child: Text('Find Location')),
            Text(
              'Longitude: ${location.longitude}\nLatitude: ${location.latitude}',
            ),
          ],
        ),
      ),
    );
  }
}
