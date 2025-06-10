import 'dart:convert';

import 'package:climafy/climafy/location.dart';
import 'package:climafy/climafy/search_page.dart';
import 'package:climafy/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeData extends StatefulWidget {
  const HomeData({super.key});
  @override
  State<HomeData> createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  final String apiKey = '05bbfb9a7a452f6f3187723b38621d0e';
  String? tempInCel;
  String? cityName;
  var weatherData;
  var emoji = '';

  Location location = Location();
  final apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=05bbfb9a7a452f6f3187723b38621d0e';

  String getImage() {
    int hour = DateTime.now().hour;

    if (hour >= 0 && hour < 5) {
      return 'assets/climafy/midnight.png';
    } else if (hour >= 5 && hour < 12) {
      return 'assets/climafy/morning.png';
    } else if (hour >= 12 && hour < 16) {
      return 'assets/climafy/midday.png';
    } else if (hour >= 16 && hour < 20) {
      return 'assets/climafy/evening.png';
    } else {
      return 'assets/climafy/night.png';
    }
  }

  void getLocation() async {
    await location.getCurrentLocation();
    double? lat = location.latitude;
    double? lon = location.longitude;

    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        tempInCel = kelToCel(data['main']['temp']);
        cityName = data['name'];
        weatherData = data;
        fetchWeatherData(data);
      });
    } else {
      print('Failed to fetch weather data');
    }
    print(response);
    print('Latitude: $lat \nLongitude: $lon');
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var imagePath = getImage();
    var textstyle = GoogleFonts.merienda(
      fontWeight: FontWeight.w900,
      fontSize: 40,
      color: black,
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: getLocation,
                      icon: Icon(Icons.near_me, size: 40, color: darkMetalic),
                    ),
                    IconButton(
                      onPressed: () async {
                        final selectedCity = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SearchPage()),
                        );

                        if (selectedCity != null && selectedCity is String) {
                          getCityWeather(selectedCity);
                        }
                      },
                      icon: Icon(
                        Icons.location_city,
                        size: 40,
                        color: darkMetalic,
                      ),
                    ),
                  ],
                ),
                Text(cityName ?? 'City Name', style: textstyle),
                Text('${tempInCel ?? '--'}°C', style: textstyle),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(emoji),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    Text(
                      weatherData != null
                          ? weatherData['weather'][0]['main']
                          : '',
                      style: textstyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String kelToCel(var temp) {
    var tempInCel = temp - 273.15;
    String tempInString = tempInCel.floor().toString();
    return tempInString;
  }

  void getCityWeather(String cityName) async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'q': cityName,
      'appid': apiKey,
    });

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        fetchWeatherData(data);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('City not found!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }

  void fetchWeatherData(dynamic data) {
    var weatherid = data['weather'][0]['id'];
    String icon;

    if (weatherid > 200 && weatherid < 300) {
      icon = 'emoji/thunder.png';
    } else if (weatherid > 300 && weatherid < 400) {
      icon = 'emoji/drizzle.png';
    } else if (weatherid > 500 && weatherid < 600) {
      icon = 'emoji/rain.png';
    } else if (weatherid > 700 && weatherid < 800) {
      icon = 'emoji/cold.png';
    } else {
      icon = 'emoji/cloud.png';
    }

    setState(() {
      emoji = icon;
      tempInCel = kelToCel(data['main']['temp']);
      cityName = data['name'];
      weatherData = data;
    });
  }
}
