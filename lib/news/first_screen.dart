import 'dart:convert';

import 'package:climafy/color.dart';
import 'package:climafy/news/news_result_screen.dart';
import 'package:climafy/news/search_news.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final String apiKey = '525b3272a5074342a509e62b3d96a7c8';
  Map<String, dynamic>? getNews;
  List<dynamic> articles = [];

  Future<void> getNewsData() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          getNews = data;
          articles = data['articles'];
        });
        print(data);
      } else {
        print('Failed to fetch news');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: Text(
          'GlobalLink',
          style: GoogleFonts.merienda(
            fontWeight: FontWeight.w900,
            color: darkSilver,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchNews()),
              );
            },
            icon: Icon(Icons.search, color: darkSilver),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getNewsData,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              articles.isEmpty && getNews == null
                  ? Center(child: CircularProgressIndicator())
                  : articles.isEmpty
                  ? Center(
                    child: Text(
                      'No news yet',
                      style: GoogleFonts.merienda(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: darkSilver,
                      ),
                    ),
                  )
                  : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 180,
                    ),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final imageUrl = article['urlToImage'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      NewsResultScreen(article: article),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    article['urlToImage'] != null
                                        ? Image.network(
                                          imageUrl,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                        : Center(
                                          child: SizedBox(
                                            height: 100,
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                              ),

                              Text(
                                article['title'] ?? 'No Title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                article['source']?['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
