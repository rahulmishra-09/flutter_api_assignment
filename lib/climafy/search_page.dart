import 'package:flutter/material.dart';

import '../color.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cityController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [lightGreen, darkGreen]),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: metalicSilver),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: TextFormField(
                    controller: cityController,
                    keyboardType: TextInputType.name,
                    autocorrect: true,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      getCity(context, cityController.text.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search city',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),

                      fillColor: metalicSilver,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      getCity(context, cityController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: darkSilver,
                      elevation: 9,
                      animationDuration: Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 25.0,
                      ),
                    ),
                    child: Text(
                      'Get City',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCity(BuildContext context, String city) {
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Center(child: Text('Enter city name first!')),
        ),
      );
    } else {
      Navigator.pop(context, city);
    }
  }
}
