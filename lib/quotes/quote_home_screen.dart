import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../color.dart';

class QuoteHomeScreen extends StatefulWidget {
  const QuoteHomeScreen({super.key});

  @override
  State<QuoteHomeScreen> createState() => _QuoteHomeScreenState();
}

class _QuoteHomeScreenState extends State<QuoteHomeScreen> {
  String quote = 'Loading quote...';
  String joke = 'Loading joke...';

  Future<void> fetchContent() async {
    try {
      final quoteResult = await fetchQuote();
      final jokeResult = await fetchJoke();

      setState(() {
        quote = quoteResult;
        joke = jokeResult;
      });
    } catch (e) {
      setState(() {
        quote = 'Failed to load quote.';
        joke = 'Failed to load joke.';
      });
    }
  }

  Future<String> fetchJoke() async {
    final url = Uri.parse('https://v2.jokeapi.dev/joke/Any');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['type'] == 'single') {
          return data['joke'];
        } else if (data['type'] == 'twopart') {
          return '${data['setup']}\n\n${data['delivery']}';
        } else {
          return 'No Joke Found';
        }
      } else {
        return 'Failed to fetch joke';
      }
    } catch (e) {
      print(e);
      return 'Error: Failed to load joke';
    }
  }

  Future<String> fetchQuote() async {
    final url = Uri.parse('https://zenquotes.io/api/random');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quote = data[0];

        return '${quote['q']} - ${quote['a']}';
      } else {
        return 'Failed to load quote';
      }
    } catch (e) {
      print(e);
      return 'Error to fetching quotes';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: quoteAppBar,
        title: Text(
          'DailyDose',
          style: GoogleFonts.zillaSlab(
            fontWeight: FontWeight.w900,
            color: darkSilver,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchContent,
        shape: CircleBorder(),
        backgroundColor: quoteAppBar,
        tooltip: 'Get New',
        elevation: 16,
        child: Icon(Icons.refresh, color: darkSilver),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(title: 'Quote of the Day', content: quote),
          const SizedBox(height: 20),
          _buildCard(title: 'Random Joke', content: joke),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2F),
              ),
            ),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
